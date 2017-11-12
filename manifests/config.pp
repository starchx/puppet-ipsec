# ipsec::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include ipsec::config
#
# @param secrets_file path to ipsec.secrets file
# @param conf_file path to ipsec.conf file
#
class ipsec::config (
  Stdlib::Absolutepath $secrets_file,
  Stdlib::Absolutepath $conf_file,
) {
  $file_ensure = $ipsec::ensure ? {
    'present' => 'file',
    default   => $ipsec::ensure,
  }
  ##
  ## build the secrets file
  ##
  file { $secrets_file:
    ensure    => $file_ensure,
    content   => epp('ipsec/secrets.epp'),
    group     => '0',
    mode      => '0600',
    owner     => '0',
    show_diff => false,
  }
  ##
  ## build the ipsec.conf file
  ##
  concat { $conf_file:
    ensure         => $ipsec::ensure,
    group          => '0',
    mode           => '0644',
    owner          => '0',
    ensure_newline => true,
    order          => 'numeric',
    warn           => true,
  }
  # create singleton setup section
  concat::fragment{ 'setup':
    target  => $conf_file,
    order   => 1,
    content => epp('ipsec/conf_setup.epp'),
  }
  # factory for ca sections
  if $ipsec::conf['authorities'] =~ Hash {
    $ipsec::conf['authorities'].each |String $name, Hash $params| {
      ipsec::conf::ca{ $name:
        * => $params
      }
    }
  }
  # factory for conn sections
  if $ipsec::conf['connections'] =~ Hash {
    $ipsec::conf['connections'].each |String $name, Hash $params| {
      ipsec::conf::conn{ $name:
        * => $params
      }
    }
  }
}
