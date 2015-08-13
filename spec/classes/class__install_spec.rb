require 'spec_helper'

describe 'pgbouncer', :type => :class do

  let(:facts) { {
    :osfamily => 'debian',
  } }

  context 'install with default settings' do
    it { should compile.with_all_deps }

    it { should contain_package('pgbouncer') }
  end

end
