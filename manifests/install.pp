#
# == Class: pgbouncer::install
#
# Install pgbouncer.
#
# === Example usage
#
# This is a private class - please see ::pgbouncer instead.
#
class pgbouncer::install {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package{ 'pgbouncer':
    name     => $pgbouncer::params::package_name:
    ensure   => $pgbouncer::package_ensure,
    provider => $pgbouncer::params::package_provider,
  }

  if $::pgbouncer::service_manage {
    case $::pgbouncer::init_style {
      'systemd': {
        file { '/lib/systemd/system/pgbouncer@.service':
          content => template('pgbouncer/pgbouncer_systemd.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0444',
        } ~>
        exec { 'pgbouncer-systemd-reload':
          command     => 'systemctl daemon-reload',
          path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
          refreshonly => true,
        }
      }
      default: {}
    }
  }

}
