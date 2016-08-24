require 'spec_helper'

describe 'pgbouncer::params', :type => :class do
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
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to have_resource_count(0) }
  end
end
