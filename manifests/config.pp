# ipsec::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include ipsec::config
class ipsec::config {
  $file_ensure = $ipsec::ensure ? {
    'present' => 'file',
    default   => $ipsec::ensure,
  }
  ##
  ## build the secrets file
  ##
  file { $ipsec::secrets_file:
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
  concat { $ipsec::conf_file:
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
    target => $ipsec::conf_file,
    order  => 1,
    content => epp('ipsec/conf_setup.epp'),
  }
  # factory for ca sections
  $ipsec::conf['authorities'].each |String $name, Hash $params| {
    ipsec::conf::ca{ $name:
      * => $params
    }
  }
  # factory for conn sections
  $ipsec::conf['connections'].each |String $name, Hash $params| {
    ipsec::conf::conn{ $name:
      * => $params
    }
  }
}
