require 'spec_helper'

describe 'pgbouncer::pg_hba_rule', :type => :define do
  SUPPORTED.each do |os|
    let(:facts) do
      {
        :osfamily => os['fam'],
        :operatingsystem => os['name'],
        :operatingsystemrelease => os['rel'],
      }
    end

    describe "on supported os #{os['name']}-#{os['rel']}" do
      let(:title)       { 'test' }

      let(:pre_condition) {
        'class { "pgbouncer": default_instance => true }'
      }

      context 'host based access rule' do
        let(:params) do
          {
            :type        => 'host',
            :database    => 'all',
            :user        => 'all',
            :address     => '127.0.0.1/32',
            :auth_method => 'trust',
          }
        end

        it { should compile.with_all_deps }

        it { should contain_concat__fragment('pgbouncer_hba_rule_test').with_content(
          /host\s+all\s+all\s+127\.0\.0\.1\/32\s+trust/
        )}
      end

    end
  end
end
