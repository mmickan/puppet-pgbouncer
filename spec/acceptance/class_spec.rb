require 'spec_helper_acceptance'
require_relative './version.rb'

case $init_style
when 'systemd'
  _service_name = 'pgbouncer@transaction'
else
  _service_name = 'pgbouncer_transaction'
end

describe 'pgbouncer class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'postgresql::globals':
        manage_package_repo => true,
        version => '9.5',
      }
      class { 'pgbouncer': }
      Yumrepo<||> -> Package<||>
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service('pgbouncer') do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe service(_service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    describe port('6432') do
      it { should be_listening.with('tcp') }
    end
  end
end
