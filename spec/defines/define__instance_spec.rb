require 'spec_helper'

describe 'pgbouncer::instance', :type => :define do
  SUPPORTED.each do |os|
    let(:facts) do
      {
        :osfamily => os['fam'],
        :operatingsystem => os['name'],
        :operatingsystemrelease => os['rel'],
      }
    end

    describe "on supported os #{os['name']}-#{os['rel']}" do
      let(:title) { 'transaction' }

      let(:pre_condition) {
        'class { "pgbouncer": default_instance => false }'
      }

      context 'with defaults' do
        it { should compile.with_all_deps }

        it { should contain_file('/etc/pgbouncer/pgbouncer_transaction.ini').that_requires('Package[pgbouncer]') }
        it { should contain_file('/etc/pgbouncer/userlist_transaction.txt').that_requires('Package[pgbouncer]') }
        it { should contain_concat('/etc/pgbouncer/pg_hba_transaction.conf').that_requires('Package[pgbouncer]') }
      end

      context 'with init_style = debian' do
        let(:pre_condition) {
          'class { "pgbouncer": default_instance => false, init_style => debian }'
        }

        it { should contain_file('/etc/init.d/pgbouncer_transaction') }
        it { should contain_service('pgbouncer_transaction') }
      end

      context 'with init_style = upstart' do
        let(:pre_condition) {
          'class { "pgbouncer": default_instance => false, init_style => upstart }'
        }

        it { should contain_file('/etc/init/pgbouncer_transaction.conf') }
        it { should contain_file('/etc/init.d/pgbouncer_transaction').with_ensure('link') }
        it { should contain_service('pgbouncer_transaction') }
      end

      context 'with init_style = systemd' do
        let(:pre_condition) {
          'class { "pgbouncer": default_instance => false, init_style => systemd }'
        }

        it { should contain_service('pgbouncer@transaction') }
      end

    end
  end
end
