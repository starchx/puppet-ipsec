# ipsec::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include ipsec::config
class ipsec::config {
  file { $ipsec::secrets_file:
    ensure  => 'file',
    content => epp('ipsec/secrets.epp'),
    group   => '0',
    mode    => '0600',
    owner   => '0',
  }
}
