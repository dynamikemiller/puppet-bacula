class puppetlabs::vor {

  File{ owner => 'root', group => 'root', mode => '0644' }

  # Install postgres from backports
  file{
    '/etc/preferences.d/postgresql9':
      ensure   => file,
      contents => "Package: postgresql\nPin: release a=squeeze-backports\nPin-Priority: 200\n";
    '/etc/apt/sources.list.d/backports.list':
      ensure   => file,
      contents => 'deb http://backports.debian.org/debian-backports squeeze-backports main',
      requires => File['/etc/preferences.d/postgresql9'];
  }

  exec{
    'refresh_apts':
      command     => '/usr/bin/aptitude --quiet update',
      refreshonly => 'true',
      requires    => File['/etc/apt/sources.list.d/backports.list'],
  }

  package{ 'postgresql-9.0': ensure => present, requires => Exec['refresh_apts'] }

}
