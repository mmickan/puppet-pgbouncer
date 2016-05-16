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
      context 'with default settings' do
        it { should compile.with_all_deps }

        it { should contain_class('pgbouncer::install').that_comes_before('Class[pgbouncer::config]') }
        it { should contain_class('pgbouncer::config') }
      end

      context 'with package_ensure set to present' do
        let(:params) do
          { :package_ensure => 'present' }
        end

        it { should compile.with_all_deps }
      end

      context 'with package_ensure set to absent' do
        let(:params) do
          { :package_ensure => 'absent' }
        end

        it { should compile.with_all_deps }
      end

      context 'with package_ensure set to specific version' do
        let(:params) do
          { :package_ensure => '1.2.3-1' }
        end

        it { should compile.with_all_deps }
      end

      context 'with invalid package_ensure' do
        let(:params) do
          { :package_ensure => 'bogus' }
        end

        it { should_not compile }
      end

      context 'with service_manage set to true' do
        let(:params) do
          { :service_manage => true }
        end

        it { should compile.with_all_deps }
      end

      context 'with service_manage set to false' do
        let(:params) do
          { :service_manage => false }
        end

        it { should compile.with_all_deps }
      end

      context 'with invalid service_manage' do
        let(:params) do
          { :service_manage => 'bogus' }
        end

        it { should_not compile }
      end

      context 'with service_restart set to true' do
        let(:params) do
          { :service_restart => true }
        end

        it { should compile.with_all_deps }
      end

      context 'with service_restart set to false' do
        let(:params) do
          { :service_restart => false }
        end

        it { should compile.with_all_deps }
      end

      context 'with invalid service_restart' do
        let(:params) do
          { :service_restart => 'bogus' }
        end

        it { should_not compile }
      end

      context 'with default_instance set to true' do
        let(:params) do
          { :default_instance => true }
        end

        it { should compile.with_all_deps }
      end

      context 'with default_instance set to false' do
        let(:params) do
          { :default_instance => false }
        end

        it { should compile.with_all_deps }
      end

      context 'with invalid default_instance' do
        let(:params) do
          { :default_instance => 'bogus' }
        end

        it { should_not compile }
      end

      context 'with init_style set to debian' do
        let(:params) do
          { :init_style => 'debian' }
        end

        it { should compile.with_all_deps }
      end

      context 'with init_style set to upstart' do
        let(:params) do
          { :init_style => 'upstart' }
        end

        it { should compile.with_all_deps }
      end

      context 'with init_style set to systemd' do
        let(:params) do
          { :init_style => 'systemd' }
        end

        it { should compile.with_all_deps }
      end

      context 'with invalid init_style' do
        let(:params) do
          { :init_style => 'bogus' }
        end

        it { should_not compile }
      end

    end
  end

  context 'on unsupported OS' do
    let(:facts) { {
      :osfamily => 'Foo',
    } }

    it { should_not compile.and_raise_error(Puppet::ParseError) }
  end

end
