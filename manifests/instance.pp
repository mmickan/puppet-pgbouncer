#
# == Define: pgbouncer::instance
#
# Configure and manage an instance of pgbouncer.
#
# === Parameters
#
# [*databases*] 
#   An array of entries to be written to the databases section in the 
#   pbbouncer.ini
#   Array entry format:
#     database_alias_name = connection_string
#
# [*logfile*]
#   The full path to the log file.
#   Default: /var/log/postgresql/pgbouncer_${name}.log
#
# [*pidfile*]
#   The full path to the pid file for the pgbouncer process.
#   Default: /var/run/postgresql/pgbouncer_${name}.pid
#
# [*listen_addr*]
#   The address on which this instance of pgbouncer should listen.
#   Default: * (all addresses)
#
# [*listen_port*]
#   The port on which this instance of pgbouncer should listen.
#   Default: 6432
#
# [*admin_users*]
#   A comma-seperated list of users allowed to access the admin console who
#   then can perform connection pool management operations and obtain
#   information about the connection pools.
#
# [*stats_users*]
#   A comma-seperated list of users allowed to access the admin console
#   who can obtain information about the connection pools.
#
# [*auth_type*]
#   Method used by PgBouncer to authenticate client connections
#   to PgBouncer. Values may be hba, cert, md5, plain, trust, or any.
#   Default: trust
#
# [*auth_list*] 
#   An array of auth values (user/password pairs).
#   This array is written to /var/lib/postgresql/pgbouncer_${name}.auth line by line.
#   Array entry format: 
#     "\"<username>\" \"<password\"
#
# [*pool_mode*]
#   Specifies when the server connection can be released back
#   into the pool. Values may be session, transaction, or statement. 
#   Default is $name
#
# [*max_client_conn*]
#   Connection limit that constrains the maximum number of clients that can
#   be connected.
#   Default: 1000
#
# [*default_pool_size*]
#   Default pool size.  20 is a good number when transaction pooling is in
#   use.  In session pooling it needs to be the maximum number of client
#   syou want to handle at any moment.
#   Default: 20
#
# === Example usage
#
#  pgbouncer::instance { 'transaction': }
#
define pgbouncer::instance(
  $databases         = $::pgbouncer::databases,
  $logfile           = "${::pgbouncer::logdir}/pgbouncer_${name}.log",
  $pidfile           = "${::pgbouncer::piddir}/pgbouncer_${name}.pid",
  $listen_addr       = $::pgbouncer::listen_addr,
  $listen_port       = $::pgbouncer::listen_port,
  $admin_users       = $::pgbouncer::admin_users,
  $stats_users       = $::pgbouncer::stats_users,
  $auth_type         = $::pgbouncer::auth_type,
  $auth_list         = $::pgbouncer::auth_list,
  $pool_mode         = $name,
  $max_client_conn   = $::pgbouncer::max_client_conn,
  $default_pool_size = $::pgbouncer::default_pool_size,
) {

  validate_array($databases)
  validate_absolute_path($logfile)
  validate_absolute_path($pidfile)
  if $listen_addr != '*' and ! is_ip_address($listen_addr) {
    fail('listen_addr must be a valid IP address')
  }
  validate_integer($listen_port)
  validate_string($admin_users)
  validate_string($stats_users)
  validate_re($auth_type, '^(hba|cert|md5|plain|trust|any)$')
  validate_array($auth_list)
  validate_re($pool_mode, '^(session|transaction|statement)$')
  validate_integer($max_client_conn)
  validate_integer($default_pool_size)

  $_config_file   = "/etc/pgbouncer/pgbouncer_${name}.ini"
  $_userlist_file = "/etc/pgbouncer/userlist_${name}.txt"
  $_hba_file      = "/etc/pgbouncer/pg_hba_${name}.conf"

  file { $_config_file:
    content => template('pgbouncer/pgbouncer.ini.erb'),
    owner   => $::pgbouncer::user,
    group   => $::pgbouncer::group,
    mode    => '0640',
    require => Package['pgbouncer'],
  }

  concat { $_hba_file:
    owner   => $::pgbouncer::user,
    group   => $::pgbouncer::group,
    mode    => '0640',
    require => Package['pgbouncer'],
  }

  file { $_userlist_file:
    content => template('pgbouncer/userlist.txt.erb'),
    owner   => $::pgbouncer::user,
    group   => $::pgbouncer::group,
    mode    => '0640',
    require => Package['pgbouncer'],
  }

  if $::pgbouncer::service_manage {
    case $::pgbouncer::init_style {
      'upstart': {
        $_service_name  = "pgbouncer_${name}"
        $_service_restart = undef

        file { "/etc/init/${_service_name}.conf":
          content => template('pgbouncer/pgbouncer_upstart.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0444',
          before  => Service[$_service_name],
        }
        file { "/etc/init.d/${_service_name}":
          ensure => 'link',
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0555',
        }
      }
      'debian': {
        $_service_name = "pgbouncer_${name}"
        $_service_restart = undef

        file { "/etc/init.d/${_service_name}":
          content => template('pgbouncer/pgbouncer_debian.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0555',
          before  => Service[$_service_name],
        }
      }
      'systemd': {
        $_service_name = "pgbouncer@${name}"
        $_service_restart = "/usr/bin/systemctl reload pgbouncer@${name}"
        Exec['pgbouncer-systemd-reload'] -> Service[$_service_name]
      }
      default: {
        fail("I don't know how to create an init script for ${::pgbouncer::init_style}")
      }
    }

    if $::pgbouncer::service_restart {
      $_service_subscribe = [
        File[$_config_file],
        Concat[$_hba_file],
        File[$_userlist_file],
      ]
    } else {
      $_service_subscribe = undef
    }

    service { $_service_name:
      ensure    => $::pgbouncer::service_ensure,
      enable    => $::pgbouncer::service_enable,
      restart   => $_service_restart,
      subscribe => $_service_subscribe,
      require   => [
        Package[$::pgbouncer::params::package_name],
        File[$_config_file],
        File[$_userlist_file],
        File['/etc/default/pgbouncer'],
      ],
    }
  }

}
