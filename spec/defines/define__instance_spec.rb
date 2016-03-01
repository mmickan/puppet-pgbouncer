require 'spec_helper'

describe 'pgbouncer::instance', :type => :define do
  let(:title) { 'transaction' }

  let(:facts) { {
    :osfamily => 'Debian',
  } }

  let(:pre_condition) {
    'class { "pgbouncer": default_instance => false }'
  }

  describe 'with defaults' do
    it { should compile.with_all_deps }

    it { should contain_file('/etc/pgbouncer/pgbouncer_transaction.ini') }
    it { should contain_file('/etc/pgbouncer/userlist_transaction.txt') }
    it { should contain_concat('/etc/pgbouncer/pg_hba_transaction.conf') }
    it { should contain_file('/etc/init.d/pgbouncer_transaction') }
    it { should contain_service('pgbouncer_transaction') }
  end

end
