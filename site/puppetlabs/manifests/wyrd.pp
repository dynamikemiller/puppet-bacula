class puppetlabs::wyrd {

  class { "apt-cacher": service => false; }

  # keeps http://wyrd.puppetlabs.lan/puppetdoc/ up to date
  cron {
    "pull ~zach/src/puppetlabs-modules":
      command => "source ~/.keychain/wyrd.sh && (cd ~zach/src/puppetlabs-modules/; git pull)",
      user => zach,  minute => '*/10';
  }

  apache::vhost {
    "wyrd.puppetlabs.lan":
      port    => 80,
      docroot => '/opt/www'
  }

  # zleslie: same issue as nagios below, a vpn would solve this
  class { "munin":  munin_server => '74.207.240.137'; }


}

