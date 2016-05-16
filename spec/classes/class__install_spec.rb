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

      context 'install with default settings' do
        it { should compile.with_all_deps }

        it { should contain_package('pgbouncer') }
      end

    end
  end
end
