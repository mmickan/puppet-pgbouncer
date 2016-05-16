require 'spec_helper'

describe 'pgbouncer', :type => :class do
  SUPPORTED.each do |os|
    let(:facts) do
      {
        :osfamily => os['fam'],
        :operatingsystem => os['name'],
        :operatingsystemrelease => os['rel'],
      }
    end

    describe "on supported os #{os['name']}-#{os['rel']}" do

      context 'config with default settings' do
        it { should compile.with_all_deps }

        it { should contain_pgbouncer__instance('transaction') }
        it { should contain_file('/etc/default/pgbouncer') }
        it { should contain_service('pgbouncer').with_ensure('stopped') }
      end

      context 'config without default instance' do
        let(:params) { {
          :default_instance => false,
        } }

        it { should compile.with_all_deps }

        it { should_not contain_pgbouncer_instance('transaction') }
      end
    end
  end
end
