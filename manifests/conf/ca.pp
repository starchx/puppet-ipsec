# ipsec::conf::ca
#
# All instances of ipsec::conf::ca resource will create ca sections within ipsec.conf file.
# However, ipsec::conf does contain a factory which creates these instanses from parameter
# ipsec::conf['authorities'], it is allowed to create instances directly.
#
# The resource takes parameter as described in Strongswan documentation (see link below).
#
# @summary Create a ca section within ipsec.conf file.
#
# @example
#   ipsec::conf::ca { 'myca':
#     auto   => 'add',
#     cacert => '/etc/ssl/certs/myca.pem',
#     crluri => 'file:///etc/ssl/crls/myca_crl.pem'
#   }
#
# @see https://wiki.strongswan.org/projects/strongswan/wiki/CaSection
#
define ipsec::conf::ca(
  Optional[String]               $also = undef,
  Optional[Enum['ignore','add']] $auto = undef,
  Optional[String]               $cacert = undef,
  Optional[String]               $crluri = undef,
  Optional[String]               $crluri2 = undef,
  Optional[String]               $ocspuri = undef,
  Optional[String]               $ocspuri2 = undef,
  Optional[String]               $certuribase = undef,
  Optional[String]               $ldaphost = undef,
) {
  concat::fragment{ "ca ${name}":
    target  => lookup('ipsec::config::conf_file'),
    order   => 2,
    content => epp('ipsec/conf_ca.epp',
    {
      'name'        => $title,
      'also'        => $also,
      'auto'        => $auto,
      'cacert'      => $cacert,
      'crluri'      => $crluri,
      'crluri2'     => $crluri2,
      'ocspuri'     => $ocspuri,
      'ocspuri2'    => $ocspuri2,
      'certuribase' => $certuribase,
      'ldaphost'    => $ldaphost,
    }),
  }
}
