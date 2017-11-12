# ipsec::install
#
# Install necessary packages.
#
# Do not use it separately.
#
# @summary Do not use it separately
#
# @param packages array of packages to be installed
#
class ipsec::install (
  Array[String] $packages,
) {
  package { $packages:
    ensure => $ipsec::ensure,
  }
}
