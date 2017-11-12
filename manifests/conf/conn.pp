# ipsec::conf::conn
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   ipsec::conf::conn { 'namevar': }
define ipsec::conf::conn(
  Optional[String]           $aaa_identity = undef,
  Optional[String]           $ah = undef,
  Optional[Enum['yes','no']] $aggressive = undef,
  Optional[String]           $also = undef,
  Optional[Enum[
    'pubkey',
    'rsasig',
    'ecdsasig',
    'pdk',
    'secret',
    'xauthrsasig',
    'xauthpsk',
    'never'
  ]]                         $authby = undef,
  Optional[Enum[
    'ignore',
    'add',
    'route',
    'start'
  ]]                         $auto = undef,
  Optional[Enum[
    'none',
    'clear',
    'hold',
    'restart'
  ]]                         $closeaction = undef,
  Optional[Enum['yes','no']] $compress = undef,
  Optional[Enum[
    'none',
    'clear',
    'hold',
    'restart'
  ]]                         $dpdaction = undef,
  Optional[Ipsec::Time]      $dpddelay = undef,
  Optional[Ipsec::Time]      $dpdtimeout = undef,
  Optional[Ipsec::Time]      $inactivity = undef,
  Optional[String]           $eap_identity = undef,
  Optional[String]           $esp = undef,
  Optional[Enum['yes','no']] $forceencaps = undef,
  Optional[Enum[
    'yes',
    'accept',
    'force',
    'no'
  ]]                         $fragmentation = undef,
  Optional[String]           $ike = undef,
  Optional[
    Pattern[/^[0-9]{6}$/]
  ]                          $ikedscp = undef,
  Optional[Ipsec::Time]      $ikelifetime = undef,
  Optional[Enum['yes','no']] $installpolicy = undef,
  Optional[Enum[
    'ike',
    'ikev1',
    'ikev2'
  ]]                         $keyexchange = undef,
  Optional[String]           $keyingtries = undef,
  Optional[Integer]          $lifebytes = undef,
  Optional[Integer]          $lifepackets = undef,
  Optional[Ipsec::Time]      $lifetime = undef,
  Optional[Integer]          $marginbytes = undef,
  Optional[Integer]          $marginpackets = undef,
  Optional[Ipsec::Time]      $margintime = undef,
  Optional[String]           $mark = undef,
  Optional[String]           $mark_in = undef,
  Optional[String]           $mark_out = undef,
  Optional[Enum['yes','no']] $mobike = undef,
  Optional[Enum[
    'push',
    'pull'
  ]]                         $modeconfig = undef,
  Optional[Enum['yes','no']] $reauth = undef,
  Optional[Enum['yes','no']] $rekey = undef,
  Optional[String]           $rekeyfuzz = undef,
  Optional[Integer]          $replay_window = undef,
  Optional[Integer]          $reqid = undef,
  Optional[Enum['yes','no']] $sha256_96 = undef,
  Optional[Integer]          $tfc = undef,
  Optional[Enum[
    'tunnel',
    'transport',
    'transport_proxy',
    'passthrough',
    'drop'
  ]]                         $type = undef,
  Optional[Enum[
    'client',
    'server'
  ]]                         $xauth = undef,
  Optional[String]           $xauth_identity = undef,
  Optional[String]           $left = undef,
  Optional[String]           $right = undef,
  Optional[Enum['yes','no']] $leftallowany = undef,
  Optional[Enum['yes','no']] $rightallowany = undef,
  Optional[String]           $leftauth = undef,
  Optional[String]           $rightauth = undef,
  Optional[String]           $leftauth2 = undef,
  Optional[String]           $rightauth2 = undef,
  Optional[String]           $leftca = undef,
  Optional[String]           $rightca = undef,
  Optional[String]           $leftca2 = undef,
  Optional[String]           $rightca2 = undef,
  Optional[String]           $leftcert = undef,
  Optional[String]           $rightcert = undef,
  Optional[String]           $leftcert2 = undef,
  Optional[String]           $rightcert2 = undef,
  Optional[String]           $leftcertpolicy = undef,
  Optional[String]           $rightcertpolicy = undef,
  Optional[String]           $leftdns = undef,
  Optional[String]           $rightdns = undef,
  Optional[Enum['yes','no']] $leftfirewall = undef,
  Optional[Enum['yes','no']] $rightfirewall = undef,
  Optional[String]           $leftgroups = undef,
  Optional[String]           $rightgroups = undef,
  Optional[String]           $leftgroups2 = undef,
  Optional[String]           $rightgroups2 = undef,
  Optional[Enum['yes','no']] $lefthostaccess = undef,
  Optional[Enum['yes','no']] $righthostaccess = undef,
  Optional[String]           $leftid = undef,
  Optional[String]           $rightid = undef,
  Optional[String]           $leftid2 = undef,
  Optional[String]           $rightid2 = undef,
  Optional[Integer]          $leftikeport = undef,
  Optional[Integer]          $rightikeport = undef,
  Optional[String]           $leftprotoport = undef,
  Optional[String]           $rightprotoport = undef,
  Optional[String]           $leftrsasigkey = undef,
  Optional[String]           $rightrsasigkey = undef,
  Optional[String]           $leftsigkey = undef,
  Optional[String]           $rightsigkey = undef,
  Optional[String]           $leftsendcert = undef,
  Optional[String]           $rightsendcert = undef,
  Optional[String]           $leftsourceip = undef,
  Optional[String]           $rightsourceip = undef,
  Optional[String]           $leftsubnet = undef,
  Optional[String]           $rightsubnet = undef,
  Optional[String]           $leftupdown = undef,
  Optional[String]           $rightupdown = undef,
  Optional[Enum['yes','no']] $mediation = undef,
  Optional[String]           $mediated_by = undef,
  Optional[String]           $me_peerid = undef,
) {
  concat::fragment{ "ca ${name}":
    target  => lookup('ipsec::config::conf_file'),
    order   => 3,
    content => epp('ipsec/conf_ca.epp'),
  }
}
