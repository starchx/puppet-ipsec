# ipsec::config
#
# Manage configuration file contents. This includes the ipsec.secrets and ipsec.conf files.
# Secrets file will, which contain many kind of secrets defined by ipsec::secrets parameter.
# The conf file consists of multiple sections of types setup, ca and conn, where there is only
# a single setup section allowed, but multiple ca and conn sections. Refer to custom type
# Ipsec::Secret for details on the structure of this parameter.
#
# @example ipsec.secret setup
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
#  ipsec::secret_includes:
#     - '/var/lib/strongswan/ipsec.secrets.inc'
#     - '/etc/ipsec.d/very.secret'
#
# Parameter ipsec::conf containes the data to generate these sections. The setup sectioin is 
# generated out of the entries found in ipsec::conf['setup'], while ipsec::conf['authorities']
# and ipsec::conf['connections'] will create instances of the according resources ipsec::conf::ca
# and ipsec::conf::conn respectively.
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
# @summary Manage configuration file contents. Must not be instanciated for its own.
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
