type Ipsec::Secret = Struct[{
  selector => Optional[Pattern[/[^:]*/]],
  secret   => Variant[
    Ipsec::Secret::Privkey,
    Ipsec::Secret::Shared,
    Ipsec::Secret::Smartcard,
    # Ipsec::Secret::NTLM,
    # Ipsec::Secret::Bliss,
  ],
}]
