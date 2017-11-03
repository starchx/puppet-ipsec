type Ipsec::Secret::Shared = Struct[{
  type       => Enum['PSK','EAP','XAUTH'],
  passphrase => String,
}]
