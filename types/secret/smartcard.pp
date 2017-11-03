type Ipsec::Secret::Smartcard = Struct[{
  type   => Enum['PIN'],
  slotnr => Optional[Integer],
  module => Optional[String],
  keyid  => Integer,
  pin    => Optional[Integer],
  prompt => Optional[Boolean],
}]
