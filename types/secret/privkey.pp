type Ipsec::Secret::Privkey = Struct[{
  type             => Enum['RSA','ECDSA','P12'],
  private_key_file => String,
  prompt           => Optional[Boolean],
  passphrase       => Optional[String],
}]
