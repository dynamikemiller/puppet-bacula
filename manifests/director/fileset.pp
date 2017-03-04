# This class handles a Director's fileset.conf entry
#
# @example
#   @@bacula::director::fileset { 'Home':
#     files => ['/home'],
#   }
#
# @param files
# @param excludes
# @param options
# @param director



define bacula::director::fileset (
  Array $files,
  String $director = $::bacula::client::director,
  Array $excludes               = [],
  Hash[String, String] $options = {'signature' => 'SHA1', 'compression' => 'GZIP9'},
  $conf_dir                     = $::bacula::conf_dir,
) {

  concat::fragment { "bacula-fileset-${name}":
    target  => "${conf_dir}/conf.d/fileset.conf",
    content => template('bacula/fileset.conf.erb'),
    tag     => "bacula-${director}",
  }
}
