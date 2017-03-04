# Class: bacula::storage
#
# Configures bacula storage daemon
#
# @param port String port to bind
# @param listen_address INET or INET6 address to listen on
# @param storage
# @param device_password
# @param device
# @param device_mode
# @param device_seltype
# @param media_type
# @param maxconcurjobs
# @param packages
# @param services
# @param homedir
# @param rundir
# @param conf_dir
# @param rundir
# @param director
# @param user
# @param group
#
class bacula::storage (
  String $port,
  String $services,
  String $packages,
  $listen_address          = $facts['ipaddress'],
  $storage                 = $facts['fqdn'], # storage here is not params::storage
  $password                = 'secret',
  $device_name             = "${trusted['fqdn']}-device",
  $device                  = '/bacula',
  $device_mode             = '0770',
  $device_owner            = $bacula::bacula_user,
  $device_seltype          = $bacula::device_seltype,
  $media_type              = 'File',
  $maxconcurjobs           = '5',
  $homedir                 = $bacula::homedir,
  $rundir                  = $bacula::rundir,
  $conf_dir                = $bacula::conf_dir,
  $director                = $bacula::params::director,
  $user                    = $bacula::bacula_user,
  $group                   = $bacula::bacula_group,
) inherits bacula {

  include ::bacula
  include bacula::virtual

  realize(Package[$packages])

  service { $services:
    ensure    => running,
    enable    => true,
    require   => Package[$packages],
  }

  if $::bacula::ssl {
    include ::bacula::ssl
    Service[$services] {
      subscribe => File[$::bacula::ssl::ssl_files],
    }
  }

  concat::fragment { 'bacula-storage-header':
    order   => 00,
    target  => "${conf_dir}/bacula-sd.conf",
    content => template('bacula/bacula-sd-header.erb'),
  }

  concat::fragment { 'bacula-storage-dir':
    target  => "${conf_dir}/bacula-sd.conf",
    content => template('bacula/bacula-sd-dir.erb'),
  }

  bacula::messages { 'Standard-sd':
    daemon   => 'sd',
    director => "${director}-dir = all",
    syslog   => 'all, !skipped',
    append   => '"/var/log/bacula/bacula-sd.log" = all, !skipped',
  }

  # Realize the clause the director is exporting here so we can allow access to
  # the storage daemon Adds an entry to ${conf_dir}/bacula-sd.conf
  Concat::Fragment <<| tag == "bacula-storage-dir-${director}" |>>

  concat { "${conf_dir}/bacula-sd.conf":
    owner     => 'root',
    group     => $group,
    mode      => '0640',
    show_diff => false,
    notify    => Service[$services],
  }

  if $media_type == 'File' {
    file { $device:
      ensure  => directory,
      owner   => $device_owner,
      group   => $group,
      mode    => $device_mode,
      seltype => $device_seltype,
      require => Package[$packages],
    }
  }

  @@bacula::director::storage { $storage:
    port          => $port,
    password      => $password,
    device_name   => $device_name,
    media_type    => $media_type,
    maxconcurjobs => $maxconcurjobs,
    tag           => "bacula-${::bacula::params::storage}",
  }
}
