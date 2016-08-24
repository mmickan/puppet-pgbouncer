require 'spec_helper_acceptance'
require_relative './version.rb'

case $init_style
when 'systemd'
  _service_prefix = 'pgbouncer@'
else
  _service_prefix = 'pgbouncer_'
end

describe 'pgbouncer::instance defined type' do

  context 'multiple instances' do

    it 'should work with no errors' do
      pp = <<-EOS
      class { 'pgbouncer':
        default_instance => false,
      }
      pgbouncer::instance { 'session':
        listen_addr => '::',
        listen_port => 5432,
      }
      pgbouncer::instance { 'transaction':
        listen_addr => '::',
        listen_port => 5433,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failure => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service("#{_service_prefix}session") do
      it { should be_enabled }
      it { should be_running }
    end

    describe service("#{_service_prefix}transaction") do
      it { should be_enabled }
      it { should be_running }
    end

    describe port('5432') do
      it { should be_listening.with('tcp6') }
    end

    describe port('5433') do
      it { should be_listening.with('tcp6') }
    end
  end
end
