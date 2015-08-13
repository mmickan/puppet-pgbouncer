require 'spec_helper'

describe 'pgbouncer', :type => :class do

  let(:facts) { {
    :osfamily => 'debian',
  } }

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
