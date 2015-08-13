require 'spec_helper'

describe 'pgbouncer', :type => :class do

  let(:facts) { {
    :osfamily => 'Debian',
  } }

  context 'with default settings' do
    it { should compile.with_all_deps }

    it { should contain_class('pgbouncer::install').that_comes_before('Class[pgbouncer::config]') }
    it { should contain_class('pgbouncer::config') }
  end

  context 'on unsupported OS' do
    let(:facts) { {
      :osfamily => 'Foo',
    } }

    it { should_not compile.and_raise_error(Puppet::ParseError) }
  end

end
