# Class: bacula::client
#
# This class installs and configures the File Daemon to backup a client system.
#
# @example
#   class { 'bacula::client': director_name => 'mydirector.example.com' }
#
# @param port The listening port for the File Daemon
# @param listen_address
# @param password
# @param max_concurrent_jobs
# @param packages
# @param services
# @param director_name
# @param storage
# @param config_file
# @param autoprune
# @param file_retention
# @param job_retention
# @param client
# @param default_pool
# @param default_pool_full
# @param default_pool_inc
# @param default_pool_diff
#
class bacula::client (
  String $packages,
  String $services,
  String $port         = '9102',
  $listen_address      = $facts['ipaddress'],
  $password            = 'secret',
  $max_concurrent_jobs = '2',
  $director_name       = $bacula::director,
  $storage             = $bacula::storage,
  $autoprune           = 'yes',
  $file_retention      = '45 days',
  $job_retention       = '6 months',
  $client              = $::fqdn,
  $default_pool        = 'Default',
  $default_pool_full   = undef,
  $default_pool_inc    = undef,
  $default_pool_diff   = undef,
) inherits bacula {

  $group    = $::bacula::bacula_group
  $conf_dir = $::bacula::conf_dir
  $config_file = "${conf_dir}/bacula-fd.conf"

  package { $packages:
    ensure => present,
  }

  service { $services:
    ensure  => running,
    enable  => true,
    require => Package[$packages],
  }

  if $::bacula::use_ssl {
    include ::bacula::ssl
    Service[$services] {
      subscribe => File[$::bacula::ssl::ssl_files],
    }
  }

  concat { $config_file:
    owner     => 'root',
    group     => $group,
    mode      => '0640',
    show_diff => false,
    require   => Package[$packages],
    notify    => Service[$services],
  }

  concat::fragment { 'bacula-client-header':
    target  => $config_file,
    content => template('bacula/bacula-fd-header.erb'),
  }

  bacula::messages { 'Standard-fd':
    daemon   => 'fd',
    director => "${director_name}-dir = all, !skipped, !restored",
    append   => '"/var/log/bacula/bacula-fd.log" = all, !skipped',
  }

  # Tell the director about this client config
  @@bacula::director::client { $client:
    port           => $port,
    client         => $client,
    password       => $password,
    autoprune      => $autoprune,
    file_retention => $file_retention,
    job_retention  => $job_retention,
    tag            => "bacula-${director_name}",
  }
}
