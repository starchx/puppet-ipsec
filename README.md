# ipsec

GitHub:
[![GitHub issues](https://img.shields.io/github/issues/rtib/puppet-ipsec.svg)](https://github.com/rtib/puppet-ipsec/issues)
[![GitHub license](https://img.shields.io/github/license/rtib/puppet-ipsec.svg)](https://github.com/rtib/puppet-ipsec/blob/master/LICENSE)
[![GitHub tag](https://img.shields.io/github/tag/rtib/puppet-ipsec.svg)](https://github.com/rtib/puppet-ipsec/releases)

Travis-CI
[![Build Status](https://travis-ci.org/rtib/puppet-ipsec.svg?branch=master)](https://travis-ci.org/rtib/puppet-ipsec)

Forge:
[![Puppet Forge](https://img.shields.io/puppetforge/v/trepasi/ipsec.svg)](https://forge.puppet.com/trepasi/ipsec)
[![Puppet Forge](https://img.shields.io/puppetforge/f/trepasi/ipsec.svg)](https://forge.puppet.com/trepasi/ipsec)
[![Puppet Forge](https://img.shields.io/puppetforge/dt/trepasi/ipsec.svg)](https://forge.puppet.com/trepasi/ipsec)

## Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with ipsec](#setup)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Defining secrets](#defining-secrets)
    * [Creating configuration](#creating-configuration)
      * [Setup section](#setup-section)
      * [Authority sections](#authority-sections)
      * [Connection sections](#connection-sections)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This puppet module is providing facility to install and configure ipsec settings. Currently using strongswan, it manages package installation, the contents of configuration files ipsec.secrets and ipsec.conf and controlling the service itself in order to reload configurations after changes. The module is designed to be fully configurable through parameter lookup, but it also allowes you to manage configuration artefacts via resource instances.

## Setup

### Beginning with ipsec

The very basic steps needed for a user to get the module up and running. This can include setup steps, if necessary, or it can be an example of the most basic use of the module.

## Usage

To get startet with this module, simply include the module into your puppet manifest. Passing parameter values may happen by direct assignment or preferably via lookup.

```puppet
include ipsec
```

The module will install strongswan on the affected nodes and care about the service to be enabled.

### Defining secrets

To add your secrets to the ```ipsec.secrets``` file, there are two options. Passing the actual secrets to the module via ```ipsec::secrets``` parameter or adding includes to the secrets file and file the secrets through other tools.

```yaml
ipsec::secrets:
  - selector: '@example.org'
    secret:
      type: PSK
      passphrase: 'asdf1234'
  - selector: 'rsa-a.example.org'
    secret:
      type: RSA
      private_key_file: '/etc/ipsec.d/private/host-a.key'
      prompt: true
  - selector: 'rsa-b.example.org'
    secret:
      type: RSA
      private_key_file: '/etc/ipsec.d/private/host-b.key'
      passphrase: 'asdf1234'
  - secret:
      type: RSA
      private_key_file: '/etc/ipsec.d/private/host-def.key'
  - secret:
      type: PIN
      slotnr: 1
      keyid: 50
      pin: 1234
  - secret:
      type: PIN
      slotnr: 1
      module: opensc
      keyid: 45
      prompt: true
```

Note, that non of the above used secrets (passphrase or pin fields) are treated as sensitive content.

The other option is to use parameter ```ipsec::secret_includes``` to include files.

```yaml
ipsec::secret_includes:
  - '/var/lib/strongswan/ipsec.secrets.inc'
  - '/etc/ipsec.d/very.secret'
```

### Creating configuration

IPSec configuration is handled within ```ipsec.conf``` file. This consists of sections of three types. All sections can be handled via ```ipsec::conf``` parameter. The setup secion is a singleton section, therefore it is handled only via the conf parameter.

#### Setup section

The hash passed in through ```ipsec::conf['setup']``` is placed as key-value pairs into the setup section of the ```ipsec.conf``` file.

#### Authority sections

The ```ipsec.conf``` file may contain multiple ca sections each configuring a certification authority. These section may be created via ```ipsec::conf['authorities']``` parameter.


```yaml
ipsec::conf:
  authorities:
    myca:
      auto: add
      cacert: '/etc/ssl/certs/myca.pem'
      crluri: 'file:///etc/ssl/crls/myca_crl.pem'
```

Alternatively, ca sections can be created by resource instances of type ```ipsec::conf::ca```.

```puppet
ipsec::conf::ca { 'myca':
  auto   => 'add',
  cacert => '/etc/ssl/certs/myca.pem',
  crluri => 'file:///etc/ssl/crls/myca_crl.pem'
```
#### Connection sections

Connections sections are created similar to authority sections. Resource instances of ```ipsec::conf::conn``` are created automatically from ```ipsec::conf['connections']``` hash parameter, or may be created directly within your puppet code.

```yaml
ipsec::conf:
  connections:
    test:
      type: transport
      left: %any
      leftcert: hostcert.pem
      right: 192.168.56.1
      rightid: %any
      auto: route
```

```puppet
ipsec::conf::conn { 'test':
  type     => 'transport',
  left     => '%any'
  leftcert => 'hostcert.pem',
  right    => '192.168.56.1',
  rightid  => '%any',
  auto     => 'route',
}
```

## Reference

* Reference documentation is created by Puppet Strings code comments, and published as gh_pages at [https://rtib.github.io/puppet-ipsec/].

### Data types

The module introduces some custom data types, which are not contained in the above reference.

#### Ipsec::Time

Represents a time value as used in Strongswan configuration. Consisting eighter of an integer or one or more numerals followed by an optional suffix, which designate the dimensions of seconds (s), minutes (m), hours (h) or days (d).

```puppet
type Ipsec::Time = Variant[Integer,Pattern[/^[0-9]+[smhd]?$/]]
```

#### Ipsec::Secret

The custom data structure to handle different types of secrets configuration for Strongswan is a bit more complex. It consists of an optional selector and a secret, which is a varian of some sub-types. The outer structure is defined as

```puppet
type Ipsec::Secret = Struct[{
  selector => Optional[Pattern[/[^:]*/]],
  secret   => Variant[
    Ipsec::Secret::Privkey,
    Ipsec::Secret::Shared,
    Ipsec::Secret::Smartcard,
  ],
}]
```

Each sub-type does have a mandatory field named type, which may decide on the applicability of the particular type.

#### Ipsec::Secret::Shared

The custom type for shared secrets is handling types ```PSK```, ```EAP``` and ```XAUTH``` and storing the passphrase as string.

```puppet
type Ipsec::Secret::Shared = Struct[{
  type       => Enum['PSK','EAP','XAUTH'],
  passphrase => String,
}]
```

Note! The passphrase is not treated as sensitive data. Use this feature of the module with care, only in the case no other solution is possible. The secrets_include parameter is providing feature to ipsec.secrets which may support other solutions for handling secret passphrase.

#### Ipsec::Secret::Privkey

Private key type secrets has one of types ```RSA```, ```ECDSA``` or ```P12```. All Privkey secrets does need a private_key_file pointing to the file path the secret key is found. It the private key needs to be unlocked, a passphrase may be filed or the prompt option enabled.

```puppet
type Ipsec::Secret::Privkey = Struct[{
  type             => Enum['RSA','ECDSA','P12'],
  private_key_file => String,
  prompt           => Optional[Boolean],
  passphrase       => Optional[String],
}]
```

Note! The passphrase is not treated as sensitive data. Use this feature with care, only in the case no other solution is possible. The secrets_include parameter is providing feature to ipsec.secrets which may support other solutions for handling secret passphrase.

#### Ipsec::Secret::Smartcard

Smartcard based authentication is supported by a secret with type ```PIN```, which mandatory takes a keyid parameter, and optional the slotnr, module name. If the card needs to be unlocked, a pin may be filed or the prompt option enabled.

```puppet
type Ipsec::Secret::Smartcard = Struct[{
  type   => Enum['PIN'],
  slotnr => Optional[Integer],
  module => Optional[String],
  keyid  => Integer,
  pin    => Optional[Integer],
  prompt => Optional[Boolean],
}]
```

Note! The pin is not treated as sensitive data. Use this feature with care, only in the case no other solution is possible. The secrets_include parameter is providing feature to ipsec.secrets which may support other solutions for handling secret pin.

## Limitations

The module is currently tested for a few OS distributions only and needs contribution to be ported and tested on others. There are features Strongswan is providing but cannot be configured with this module, e.g. NTLM based authentication. Feel free to contribute missing features.

## Development

Puppet modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. Please follow the usual guidelines when contributing changes.
1. fork the repository on GitHub
1. make your improvements, preferably to a feature branch
1. rebase your changes to the head of the master branch
1. squash your changes into a single commit
1. file a pull request and check the result of Travis-CI tests

## Donate

If you like this project feel free to support via Bitcoin
[![BitCoin Wallet 1GYq2ycFk3gXdQ2dn6V8YARFL52mVi3Wtj](https://github.com/rtib/puppet-ipsec/raw/master/donate.png)](bitcoin:1GYq2ycFk3gXdQ2dn6V8YARFL52mVi3Wtj?label=donate%3A%20PuppetForge%20trepasi%20ipsec)
