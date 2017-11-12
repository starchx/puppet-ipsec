# ipsec
#
# This is the main entry point and single resource to be instanciated in your puppet code.
#
# @summary Main entry point to this module and the only resource to be instanciated.
#
# @example
#   include ipsec
#
# @param ensure ensure meta-parameter to add or remove config done by this module
# @param secrets array of secrets to be added to ipsec.secrets
# @param secret_includes array of paths to files to be included to ipsec.secrets
# @param conf Hash of ipsec.conf entries; for details see [https://wiki.strongswan.org/projects/strongswan/wiki/IpsecConf]
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
