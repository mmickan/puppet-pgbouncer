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
    ensure   => $pgbouncer::package_ensure,
    name     => $pgbouncer::params::package_name,
    provider => $pgbouncer::params::package_provider,
  }

  if $::pgbouncer::user_manage {
    user { $::pgbouncer::user:
      ensure  => 'present',
      system  => true,
      gid     => $::pgbouncer::group,
      # at least on Ubuntu, pgbouncer depends on the postgresql-common
      # package which provides the postgres user (and there's no harm in
      # this require on systems where that's not the case)
      require => Package['pgbouncer'],
    }
  }

  if $::pgbouncer::group_manage {
    group { $::pgbouncer::group:
      ensure  => 'present',
      system  => true,
      # at least on Ubuntu, pgbouncer depends on the postgresql-common
      # package which provides the postgres group (and there's no harm in
      # this require on systems where that's not the case)
      require => Package['pgbouncer'],
    }
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
