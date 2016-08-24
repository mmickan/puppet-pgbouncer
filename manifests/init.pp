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
# [*user_manage*]
#   Boolean.  Whether or not this module should manage the user to run
#   pgbouncer as.
#   Default: true
#
# [*group_manage*]
#   Boolean.  Whether or not this module should manage the group to run
#   pgbouncer as.
#   Default: true
#
# [*user*]
#   String.  The user to run pgbouncer as.
#   Default: depends on operating system family
#
# [*group*]
#   String.  The group to run pgbouncer as.
#   Default: depends on operating system family
#
# See the pgbouncer::instance defined type for an explanation of the
# remaining paramaters.
#
# === Examples
#
#  class { pgbouncer: }
#
class pgbouncer (
  $package_ensure    = 'present',
  $service_manage    = true,
  $service_restart   = true,
  $default_instance  = true,
  $init_style        = $::pgbouncer::params::init_style,
  $user_manage       = true,
  $group_manage      = true,
  $user              = $::pgbouncer::params::user,
  $group             = $::pgbouncer::params::group,

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

  # paths that vary by OS - shouldn't need to change these
  $piddir            = $::pgbouncer::params::piddir,
  $logdir            = $::pgbouncer::params::logdir,
  $bindir            = $::pgbouncer::params::bindir,
) inherits pgbouncer::params {

  validate_bool($service_manage)
  validate_bool($service_restart)
  validate_bool($default_instance)
  validate_re($package_ensure, '^(absent|present|[\d\.\-]+)$', 'invalid $package_ensure')
  validate_absolute_path($piddir)
  validate_absolute_path($logdir)
  validate_bool($user_manage)
  validate_bool($group_manage)
  validate_string($user)
  validate_string($group)

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
