# This class is here to hold the data about a bacula instalation.
class bacula (
  String $conf_dir,
  String $bacula_user,
  String $bacula_group,
  String $homedir,
  String $homedir_mode = '0770',
  Boolean $monitor       = true,
  String $device_seltype = 'bacula_store_t',
  Boolean $ssl = false,
){

  if $ssl {
    include bacula::ssl
  }
}
