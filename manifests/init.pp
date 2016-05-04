#
# == Class: pgbouncer
#
# Deploy and manage pgbouncer, including package installation and
# configuration of one or more instances (to allow different pool modes on
# different ports).
#
# === Parameters
#
# [*package_ensure*]
#   (present|absent|<version>) Determines whether or not the package will be
#   installed, and what version will be installed.
#
# [*service_manage*]
#   Boolean.  Whether or not Puppet should manage the configured pgbouncer
#   service(s).
#
# [*service_restart*]
#   Boolean.  Whether or not Puppet should restart pgbouncer instances when
#   their configuration is changed.
#
# [*default_instance*]
#   Boolean.  Whether or not to manage a default pgbouncer instance.  The
#   default instance is usually sufficient when only a single pgbouncer
#   instance is required.
#
# [*init_style*]
#   String.  The init system in use.
#   Valid values: debian, upstart, systemd (others are easy to add though!)
#   Default: depends on operating system and version.
#
# See the pgbouncer::instance defined type for an explanation of the
# remaining paramaters.
#
# === Examples
#
#  class { pgbouncer: }
#
class pgbouncer (
  $package_ensure   = 'present',
  $service_manage   = true,
  $service_restart  = true,
  $default_instance = true,
  $init_style       = $::pgbouncer::params::init_style,

  # defaults for per-pool settings
  $databases         = [],
  $listen_addr       = '*',
  $listen_port       = '6432',
  $admin_users       = 'postgres',
  $stats_users       = 'postgres',
  $auth_type         = 'trust',
  $auth_list         = [],
  $max_client_conn   = 1000,
  $default_pool_size = 20,
) inherits pgbouncer::params {

  validate_bool($service_manage)
  validate_bool($service_restart)
  validate_bool($default_instance)

  if $package_ensure == 'absent' {
    $service_ensure = 'stopped'
    $service_enable = false
  } else {
    $service_ensure = 'running'
    $service_enable = true
  }
 
  anchor { 'pgbouncer::begin': } ->
  class { 'pgbouncer::install': } ->
  class { 'pgbouncer::config': } ->
  anchor { 'pgbouncer::end': }

}
