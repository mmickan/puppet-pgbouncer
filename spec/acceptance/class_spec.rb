require 'spec_helper_acceptance'

describe 'pgbouncer class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'pgbouncer': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service('pgbouncer') do
# should_not be_enabled doesn't work due to a bug in the serverspec test
# that finds the pgbouncer transaction service and triggers a failure
#     it { should_not be_enabled }
      it { should_not be_running }
    end
    # perform the equivalent of the test commented out above, with the
    # serverspec bug fixed (serverspec doesn't include the '$' on the end of
    # grep's regex, thus matches pgbouncer_transaction when it shouldn't)
    describe command('ls /etc/rc3.d/ | grep -- "^S..pgbouncer$"') do
      its(:exit_status) { should eq 1 }
    end

    describe service('pgbouncer_transaction') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port('6432') do
      it { should be_listening.with('tcp') }
    end
  end
end
