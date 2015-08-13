#
# == Class: pgbouncer::config
#
# Manage pgbouncer global configuration.  See pgbouncer::instance for
# per-instance configuration.
#
# === Example usage
#
# This is a private class, do not call directly - see ::pgbouncer instead.
#
class pgbouncer::config {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $pgbouncer::default_instance {
    pgbouncer::instance { 'transaction': }
  }

  file { '/etc/default/pgbouncer':
    source  => 'puppet:///modules/pgbouncer/pgbouncer',
  }

  # we start each pgbouncer instance from init scripts with an instance name
  # suffix and don't use the package-supplied single instance init script
  service { 'pgbouncer':
    ensure => 'stopped',
    enable => false,
  }

}
