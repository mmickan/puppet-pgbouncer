require 'spec_helper_acceptance'

describe 'pgbouncer::pg_hba_rule defined type' do

  context 'multiple rules' do

    it 'should work with no errors' do
      pp = <<-EOS
      class { 'pgbouncer': }
      pgbouncer::pg_hba_rule { 'rule1':
        type        => 'local',
        database    => 'all',
        user        => 'all',
        auth_method => 'trust',
      }
      pgbouncer::pg_hba_rule { 'rule2':
        type        => 'host',
        database    => 'all',
        user        => 'all',
        address     => '127.0.0.1/32',
        auth_method => 'trust',
        order       => '200',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failure => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/pgbouncer/pg_hba_transaction.conf') do
      it { should be_mode 640 }
      its(:content) { should match /^local\s+all\s+all\s+trust$/ }
      its(:content) { should match /^host\s+all\s+all\s+127\.0\.0\.1\/32\s+trust$/ }
    end
  end
end
