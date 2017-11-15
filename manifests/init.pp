# Puppet module for IPsec
#
# This puppet module is providing facility to install and configure ipsec settings.
# Currently using strongswan, it manages package installation, the contents of
# configuration files ipsec.secrets and ipsec.conf and controlling the service itself
# in order to reload configurations after changes. The module is designed to be fully
# configurable through parameter lookup.
#
# Secrets are added to the ipsec.secrets file through the secrets parameter of the
# module. Consisting of an array of custom typed entries, all entries are added as
# individual secret etries. Parameter secrets_includes provides the possibility to
# include auxiliary secret files.
#
# @example specification of secrets
#  ipsec::secrets: 
#    - selector: '@example.org'
#      secret:
#        type: PSK
#        passphrase: 'asdf1234'
#    - selector: 'rsa-a.example.org'
#      secret:
#        type: RSA
#        private_key_file: '/etc/ipsec.d/private/host-a.key'
#        prompt: true
#    - selector: 'rsa-b.example.org'
#      secret:
#      type: RSA
#       private_key_file: '/etc/ipsec.d/private/host-b.key'
#       passphrase: 'asdf1234'
#    - secret:
#         type: RSA
#         private_key_file: '/etc/ipsec.d/private/host-def.key'
#    - secret:
#         type: PIN
#         slotnr: 1
#         keyid: 50
#         pin: 1234
#    - secret:
#         type: PIN
#         slotnr: 1
#         module: opensc
#         keyid: 45
#         prompt: true
#
# @example secret includes
#  ipsec::secret_includes:
#     - '/var/lib/strongswan/ipsec.secrets.inc'
#     - '/etc/ipsec.d/very.secret'
#
# The contents of ipsec.conf, as it consists of three different types of entries, is
# generated upon the fixed structure parameter named conf. As the setup section is
# singleton within ipsec.conf, the conf['setup'] hash only includes the actual setup
# key-value pairs. Entries ```conf['authorities']``` and ```conf['connections']``` are
# processed in a factory pattern, creating the according resource instances, which build
# the actual sections of the ipsec.conf file. The possibility of configuration fragments
# placed in /etc/ipsec.d/ is not utilised.
#
# @example ca settings
#  ipsec::conf::authorities:
#    myca:
#      auto: add
#      cacert: /etc/ssl/certs/myca.pem
#      crluri: file:///etc/ssl/crls/myca_crl.pem
#
# @example conn settings
#  ipsec::conf::connections:
#    test:
#      type: transport
#      left: %any
#      leftcert: hostcert.pem
#      right: 192.168.56.1
#      rightid: %any
#      auto: route
# 
# @summary Main entry point to this module.
#
# @example
#   include ipsec
#
# @param ensure ensure meta-parameter to add or remove config done by this module
# @param secrets array of secrets to be added to ipsec.secrets
# @param secret_includes array of paths to files to be included to ipsec.secrets
# @param conf Hash of ipsec.conf entries; for details see IpsecConf documentation
#
# @see https://wiki.strongswan.org/projects/strongswan/wiki/IpsecConf
#
class ipsec (
  Enum['present', 'absent']   $ensure,
  Array[Ipsec::Secret]        $secrets,
  Array[Stdlib::Absolutepath] $secret_includes,
  Struct[{
    setup       => Optional[Hash[String,Hash]],
    authorities => Optional[Hash[String,Hash]],
    connections => Optional[Hash[String,Hash]],
  }]                          $conf,
) {
  contain ipsec::install
  contain ipsec::config
  contain ipsec::service

  Class['ipsec::install']
  -> Class['ipsec::config']
  ~> Class['ipsec::service']
}
