#
# == Class: pgbouncer::params
#
# System-specific configuration options for pgbouncer.
#
# === Example usage
#
# This class should not be called directly - see ::pgbouncer instead.
#
class pgbouncer::params {

  case $::osfamily {
    'debian': {
      $package_name     = 'pgbouncer'
      $package_provider = undef
    }
    default: {
      fail("Unsupported OS ${::osfamily}.  Please use a debian based system")
    }
  }

}
