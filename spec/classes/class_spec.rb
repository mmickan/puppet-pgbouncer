require 'spec_helper'

describe 'pgbouncer', :type => :class do
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
    it { is_expected.to contain_class('pgbouncer') }
    it { is_expected.to contain_class('pgbouncer::params') }
    it { is_expected.to contain_class('pgbouncer::install') }
    it { is_expected.to contain_class('pgbouncer::config') }
    it { is_expected.to contain_anchor('pgbouncer::begin') }
    it { is_expected.to contain_anchor('pgbouncer::end') }

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
        it { is_expected.to compile.with_all_deps }
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
    it { is_expected.to contain_class('pgbouncer') }
    it { is_expected.to contain_class('pgbouncer::params') }
    it { is_expected.to contain_class('pgbouncer::install') }
    it { is_expected.to contain_class('pgbouncer::config') }
    it { is_expected.to contain_anchor('pgbouncer::begin') }
    it { is_expected.to contain_anchor('pgbouncer::end') }
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
