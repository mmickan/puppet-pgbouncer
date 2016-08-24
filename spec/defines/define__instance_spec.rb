require 'spec_helper'

describe 'pgbouncer::instance', :type => :define do
  let :pre_condition do
    'class { "pgbouncer": default_instance => false }'
  end
  let :title do
    'transaction'
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
    it { is_expected.to contain_file('/etc/pgbouncer/pgbouncer_transaction.ini') }
    it { is_expected.to contain_concat('/etc/pgbouncer/pg_hba_transaction.conf') }
    it { is_expected.to contain_file('/etc/pgbouncer/userlist_transaction.txt') }
    it { is_expected.to contain_service('pgbouncer@transaction') }

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
        it { is_expected.to contain_file('/etc/init/pgbouncer_transaction.conf') }
        it { is_expected.to contain_file('/etc/init.d/pgbouncer_transaction').with_ensure('link') }
        it { is_expected.to contain_service('pgbouncer_transaction') }
        it { is_expected.not_to contain_service('pgbouncer@transaction') }
      end

      context '16.04' do
        let :facts do
          super().merge({
            :lsbdistrelease         => '16.04',
            :operatingsystemrelease => '16.04',
          })
        end
        it { is_expected.to contain_service('pgbouncer@transaction') }
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
    it { is_expected.to contain_file('/etc/pgbouncer/pgbouncer_transaction.ini') }
    it { is_expected.to contain_concat('/etc/pgbouncer/pg_hba_transaction.conf') }
    it { is_expected.to contain_file('/etc/pgbouncer/userlist_transaction.txt') }
    it { is_expected.to contain_service('pgbouncer@transaction') }
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
