define bacula::director::client (
  $port,
  $client,
  $password,
  $file_retention,
  $job_retention,
  String $autoprune,
  $conf_dir = $::bacula::conf_dir
) {

  concat::fragment { "bacula-director-client-${client}":
    target  => "${conf_dir}/conf.d/client.conf",
    content => template('bacula/bacula-dir-client.erb'),
  }
}
