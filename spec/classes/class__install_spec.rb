require 'spec_helper'

describe 'pgbouncer::install', :type => :class do
  let :pre_condition do
    'include pgbouncer'
  end
  context 'on a Debian OS' do
    let :facts do
      {
        :id                     => 'root',
        :kernel                 => 'Linux',
        :lsbdistcodename        => 'jessie',
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '8.0',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end
    it { is_expected.to contain_package('pgbouncer') }
    it { is_expected.to contain_user('postgres') }
    it { is_expected.to contain_group('postgres') }
    it { is_expected.to contain_file('/lib/systemd/system/pgbouncer@.service') }
    it { is_expected.to contain_exec('pgbouncer-systemd-reload') }

    context 'with $user_manage => false' do
      let :pre_condition do
        'class { "pgbouncer": user_manage => false }'
      end
      it { is_expected.not_to contain_user('postgres') }
    end

    context 'with $group_manage => false' do
      let :pre_condition do
        'class { "pgbouncer": group_manage => false }'
      end
      it { is_expected.not_to contain_group('postgres') }
    end

    context 'with $service_manage => false' do
      let :pre_condition do
        'class { "pgbouncer": service_manage => false }'
      end
      it { is_expected.not_to contain_file('/lib/systemd/system/pgbouncer@.service') }
      it { is_expected.not_to contain_exec('pgbouncer-systemd-reload') }
    end

    context 'on Ubuntu' do
      let :facts do
        super().merge({
          :operatingsystem => 'Ubuntu',
        })
      end

      context '14.04' do
        let :facts do
          super().merge({
            :lsbdistrelease         => '14.04',
            :operatingsystemrelease => '14.04',
          })
        end
        it { is_expected.not_to contain_file('/lib/systemd/system/pgbouncer@.service') }
        it { is_expected.not_to contain_exec('pgbouncer-systemd-reload') }
      end

      context '16.04' do
        let :facts do
          super().merge({
            :lsbdistrelease         => '16.04',
            :operatingsystemrelease => '16.04',
          })
        end
        it { is_expected.to compile.with_all_deps }
      end
    end
  end

  context 'on a RedHat 7 OS' do
    let :facts do
      {
        :id                     => 'root',
        :kernel                 => 'Linux',
        :osfamily               => 'RedHat',
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '7.2.1511',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end
    it { is_expected.to contain_package('pgbouncer') }
    it { is_expected.to contain_user('pgbouncer') }
    it { is_expected.to contain_group('pgbouncer') }
    it { is_expected.to contain_file('/lib/systemd/system/pgbouncer@.service') }
    it { is_expected.to contain_exec('pgbouncer-systemd-reload') }

    context 'with $user_manage => false' do
      let :pre_condition do
        'class { "pgbouncer": user_manage => false }'
      end
      it { is_expected.not_to contain_user('pgbouncer') }
    end

    context 'with $group_manage => false' do
      let :pre_condition do
        'class { "pgbouncer": group_manage => false }'
      end
      it { is_expected.not_to contain_group('pgbouncer') }
    end

    context 'with $service_manage => false' do
      let :pre_condition do
        'class { "pgbouncer": service_manage => false }'
      end
      it { is_expected.not_to contain_file('/lib/systemd/system/pgbouncer@.service') }
      it { is_expected.not_to contain_exec('pgbouncer-systemd-reload') }
    end
  end

  context 'with unsupported osfamily' do
    let :facts do
      {
        :osfamily => 'Darwin',
        :operatingsystemrelease => '13.1.0',
        :concat_basedir => '/dne',
      }
    end

    it do
      expect {
        catalogue
      }.to raise_error(Puppet::Error, /Unsupported OS/)
    end
  end
end
