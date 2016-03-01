require 'spec_helper'

describe 'pgbouncer::pg_hba_rule', :type => :define do
  let(:title)       { 'test' }

  let(:facts) { {
    :osfamily => 'Debian',
  } }

  let(:pre_condition) {
    'class { "pgbouncer": default_instance => true }'
  }

  describe 'with defaults' do
    let(:params) { {
      :type        => 'host',
      :database    => 'all',
      :user        => 'all',
      :address     => '127.0.0.1/32',
      :auth_method => 'trust',
    } 
    }
    it { should compile.with_all_deps }

    it { should contain_concat__fragment('pg_hba_rule_test').with_content(
      /host\s+all\s+all\s+127\.0\.0\.1\/32\s+trust/
    )}
  end

end
