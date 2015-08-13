#pgbouncer

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What pgbouncer does and why it is useful](#module-description)
3. [Setup - The basics of getting started with [pgbouncer]](#setup)
    * [What [pgbouncer] affects](#what-[pgbouncer]-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with [pgbouncer]](#beginning-with-[pgbouncer])
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to pgbouncer](#development)

##Overview

Deploy and configure [PgBouncer](http://pgbouncer.github.io).

Tested with Ubuntu 14.04, but should work on other systems with minor
tweaks.

##Module Description

This module downloads and installs the package, writes configuration files
and manages one or more instances of the pgbouncer service.

##Setup

###What [pgbouncer] affects

* Deploys per-instance configuration to /etc/pgbouncer/pgbouncer_*.ini
* Deploys per-instance user lists to /etc/pgbouncer/userlist_*.txt
* Enables pgbouncer in /etc/default/pgbouncer
* Disables package-provided pgbouncer init script, deploys and enables
    per-intsance init script.

###Setup Requirements

Requires the puppetlabs/stdlib module.

###Beginning with [pgbouncer]

The module provides sensible defaults for a single instance configuration.
To deploy a transaction pooling instance only:

```puppet
class { 'pgbouncer': }
```

To deploy multiple instances, you'll need to at least specify a port for one
of them:

```puppet
class { 'pgbouncer':
  default_instance => false,
}

pgbouncer::instance { 'session':
  listen_port => '6432',
}
pgbouncer::instance { 'transaction':
  listen_port => '6433',
}
```

##Usage

Full documentation of parameters is included in the init.pp and instance.pp
manifest files.

##Reference

Only the "pgbouncer" class and the "pgbouncer::instance" defined type should
be instantiated directly - all other classes are private.

##Limitations

Currently this module will fail if $::osfamily is not Debian, and it's only
been tested on Ubuntu 14.04.  Support for other operating systems and
distributions should be a simple matter; most of the basic structure is
already in place.

##Development

Contributions are welcome.  Open an
[issue](https://github.com/mmickan/puppet-pgbouncer/issues) or
[fork](https://github.com/mmickan/puppet-pgbouncer/fork) and open a [pull
request](https://github.com/mmickan/puppet-pgbouncer/pulls).  Passing tests
are appreciated with pull requests, but not a hard requirement.  Please
ensure your commit message clearly explains the problem your patch solves.

##Contributors

Written by Mark Mickan <mark.mickan@blackboard.com>.

Thanks to Michael Speth for the
[landcareresearch/pgbouncer](https://bitbucket.org/landcareresearch/puppet-pgbouncer)
module, which parts of this module are based on.
