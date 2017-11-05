# ipsec
#
# This is the main entry point and single resource to be instanciated in your puppet code.
#
# @summary Main entry point to this module and the only resource to be instanciated.
#
# @example
#   include ipsec
class ipsec (
  Enum['present', 'absent']   $ensure,
  Array[String]               $packages,
  Stdlib::Absolutepath        $secrets_file,
  Array[Ipsec::Secret]        $secrets,
  Array[Stdlib::Absolutepath] $secret_includes,
) {
  contain ipsec::install
  contain ipsec::config
  contain ipsec::service

  Class['ipsec::install']
  -> Class['ipsec::config']
  ~> Class['ipsec::service']
}
