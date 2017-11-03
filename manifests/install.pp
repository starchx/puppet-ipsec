# ipsec::install
#
# Install necessary packages.
#
# Do not use it separately.
#
# @summary Do not use it separately
class ipsec::install {
  package { $ipsec::packages:
    ensure => $ipsec::ensure,
  }
}
