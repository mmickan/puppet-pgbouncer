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

  package{ $pgbouncer::params::package_name:
    ensure   => $pgbouncer::package_ensure,
    provider => $pgbouncer::params::package_provider,
  }

}
