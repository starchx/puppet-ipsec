# ipsec::conf::ca
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   ipsec::conf::ca { 'namevar': }
define ipsec::conf::ca(
  Optional[String]               $also = undef,
  Optional[Enum['ignore','add']] $auto = undef,
  Optional[String]               $cacert = undef,
  Optional[String]               $crluri = undef,
  Optional[String]               $crluri2 = undef,
  Optional[String]               $ocspuri = undef,
  Optional[String]               $ocspuri2 = undef,
  Optional[String]               $certunribase = undef,
  Optional[String]               $ldaphost = undef,
) {
  concat::fragment{ "ca ${name}":
    target  => lookup('ipsec::config::conf_file'),
    order   => 2,
    content => epp('ipsec/conf_ca.epp'),
  }
}
