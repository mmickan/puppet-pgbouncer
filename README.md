#pgbouncer

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What pgbouncer does and why it is useful](#module-description)
3. [Setup - The basics of getting started with pgbouncer](#setup)
    * [What pgbouncer affects](#what-pgbouncer-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pgbouncer](#beginning-with-pgbouncer)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to pgbouncer](#development)

##Overview

Deploy and configure [PgBouncer](http://pgbouncer.github.io), including
multiple instances and host-based access control.

##Module Description

This module downloads and installs the package, writes configuration files
and manages one or more instances of the pgbouncer service.

##Setup

###What pgbouncer affects

* Deploys per-instance configuration to `/etc/pgbouncer/pgbouncer_*.ini`
* Deploys per-instance user lists to `/etc/pgbouncer/userlist_*.txt`
* Deploys per-instance host-based access configuration to
    `/etc/pgbouncer/pg_hba_*.conf`
* Enables pgbouncer in `/etc/default/pgbouncer`
* Disables package-provided pgbouncer init script, deploys and enables
    per-instance init script

###Setup Requirements

* Requires the puppetlabs/stdlib module
* Requires the puppetlabs/concat module if using host-based access
* Requires the puppetlabs/postgresql module only for the package repo

###Beginning with pgbouncer

It is recommended that you use the puppetlabs/postgresql module to install
the required repository:

```puppet
class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '9.5',
}
Yumrepo<||> -> Package['pgbouncer']
```

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

Full documentation of parameters is included in the `init.pp`,
`instance.pp`, and `pg_hba_rule.pp` manifest files.

##Reference

Only the `pgbouncer` class and the `pgbouncer::instance` and
`pgbouncer::pg_hba_rule` defined type should be instantiated directly - all
other classes are private.

##Limitations

Tested on:

* CentOS 7
* Debian 8
* Ubuntu 14.04
* Ubuntu 16.04

Tested using:

* Puppet 3.8
* Puppet 4.6

##Development

Contributions are welcome.  Open an
[issue](https://github.com/mmickan/puppet-pgbouncer/issues) or
[fork](https://github.com/mmickan/puppet-pgbouncer/fork) and open a [pull
request](https://github.com/mmickan/puppet-pgbouncer/pulls).  Passing tests
are appreciated with pull requests, but not a hard requirement.  Please
ensure your commit message clearly explains the problem your patch solves.

##Contributors

* Mark Mickan (mmickan)
* Anton Fletcher (salmonmoose)
