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
      $user             = 'postgres'
      $group            = 'postgres'
      $piddir           = '/var/run/postgresql'
      $logdir           = '/var/log/postgresql'
      $bindir           = '/usr/sbin'
    }
    'redhat': {
      $package_name     = 'pgbouncer'
      $package_provider = undef
      $user             = 'pgbouncer'
      $group            = 'pgbouncer'
      $piddir           = '/var/run/pgbouncer'
      $logdir           = '/var/log/pgbouncer'
      $bindir           = '/usr/bin'
    }
    default: {
      fail("Unsupported OS family ${::osfamily}")
    }
  }

  case $::operatingsystem {
    'Ubuntu': {
      if versioncmp($::operatingsystemrelease, '8.04') < 1 {
        $init_style = 'debian'
      } elsif versioncmp($::operatingsystemrelease, '15.04') < 0 {
        $init_style = 'upstart'
      } else {
        $init_style = 'systemd'
      }
    }
    /Scientific|CentOS|RedHat|OracleLinux/: {
      if versioncmp($::operatingsystemrelease, '7.0') < 0 {
        $init_style = 'sysv'
      } else {
        $init_style = 'systemd'
      }
    }
    'Fedora': {
      if versioncmp($::operatingsystemrelease, '12') < 0 {
        $init_style = 'sysv'
      } else {
        $init_style = 'systemd'
      }
    }
    'Debian': {
      if versioncmp($::operatingsystemrelease, '8.0') < 0 {
        $init_style = 'debian'
      } else {
        $init_style = 'systemd'
      }
    }
    'ArchLinux': {
      $init_style = 'systemd'
    }
    'SLES': {
      $init_style = 'sles'
    }
    'Darwin': {
      $init_style = 'launchd'
    }
    'Amazon': {
      $init_style = 'sysv'
    }
    default: {
      fail('Unsupported OS')
    }
  }

}
