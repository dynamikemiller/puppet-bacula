# Class: bacula::virtual
#
# This class contains virtual resources shared between the bacula::director
# and bacula::storage classes.
#
class bacula::virtual {
  # Get the union of all the packages so we prevent having duplicate packages,
  # which is exactly the reason for having a virtual package resource.

  $director_packages = lookup('bacula::director::packages')
  $storage_packages  = lookup('bacula::storage::packages')
  $packages          = ($director_packages + $storage_packages).unique

  @package { $packages:
    ensure => present
  }
}
