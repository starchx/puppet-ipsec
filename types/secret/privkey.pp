type Ipsec::Secret::Privkey = Struct[{
  type             => Enum['RSA','ECDSA','P12'],
  private_key_file => Stdlib::Absolutepath,
  prompt           => Optional[Boolean],
  passphrase       => Optional[String],
}]
