# Class: bacula::params
#
# Set some platform specific paramaters.
#
class bacula::params (
  $storage,
  $director,
  $director_address,
  $job_tag,
) {

  #validate_bool($ssl)

  #if $facts['operatingsystem'] in ['RedHat', 'CentOS', 'Fedora', 'Scientific'] {
  #  $db_type        = hiera('bacula::params::db_type', 'postgresql')
  #} else {
  #  $db_type        = hiera('bacula::params::db_type', 'pgsql')
  #}


  case $facts['operatingsystem'] {
    'Ubuntu','Debian': {
    }
    'SLES': {
    }
    'RedHat','CentOS','Fedora','Scientific': {
    }
    'FreeBSD': {
    }
    'OpenBSD': {
    }
    default: { fail("bacula::params has no love for ${facts['operatingsystem']}") }
  }

  #$certfile = "${conf_dir}/ssl/${::clientcert}_cert.pem"
  #$keyfile  = "${conf_dir}/ssl/${::clientcert}_key.pem"
  #$cafile   = "${conf_dir}/ssl/ca.pem"
}
