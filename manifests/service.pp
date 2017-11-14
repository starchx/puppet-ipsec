# ipsec::service
#
# Manage the service needed for ipsec operations. Do not include this class on its own.
#
# @summary Service management class for IPSec
#
class ipsec::service (
  String $service_name,
  String $service_restart,
) {
  service { $service_names:
    enable    => true,
    hasstatus => false,
    restart   => $service_restart,
  }
}
