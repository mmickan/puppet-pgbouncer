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
  $logfile           = "/var/log/postgresql/pgbouncer_${name}.log",
  $pidfile           = "/var/run/postgresql/pgbouncer_${name}.pid",
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

  $_service_name  = "pgbouncer_${name}"
  $_config_file   = "/etc/pgbouncer/pgbouncer_${name}.ini"
  $_userlist_file = "/etc/pgbouncer/userlist_${name}.txt"
  $_hba_file      = "/etc/pgbouncer/pg_hba_${name}.conf"

  if $::pgbouncer::service_restart and $::pgbouncer::service_manage {
    $_service_notify = Service[$_service_name]
  } else {
    $_service_notify = undef
  }

  file { $_config_file:
    content => template('pgbouncer/pgbouncer.ini.erb'),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0640',
    require => Package[$::pgbouncer::params::package_name],
    notify  => $_service_notify,
  }

  concat { $_hba_file:
    owner  => 'postgres',
    group  => 'postgres',
    mode   => '0640',
    notify => $_service_notify,
  }

  file { $_userlist_file:
    content => template('pgbouncer/userlist.txt.erb'),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0640',
    require => Package[$::pgbouncer::params::package_name],
    notify  => $_service_notify,
  }

  if $::pgbouncer::service_manage {
    file { "/etc/init.d/${_service_name}":
      content => template('pgbouncer/pgbouncer_init.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    } ->

    service { $_service_name:
      ensure  => $::pgbouncer::service_ensure,
      enable  => $::pgbouncer::service_enable,
      require => [
        Package[$::pgbouncer::params::package_name],
        File[$_config_file],
        File[$_userlist_file],
        File['/etc/default/pgbouncer'],
      ],
    }
  }

}
