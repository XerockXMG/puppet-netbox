# = Class: netbox::config

class netbox::config {
  file { "${netbox::directory}/netbox/netbox/configuration.py":
    ensure  => 'present',
    content => epp("${module_name}/configuration.py.epp"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Vcsrepo["${netbox::directory}"]
  }

  file { 'install script':
    ensure  => present,
    content => epp("${module_name}/installation.sh.epp"),
    path    => "${netbox::directory}/installation.sh",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Vcsrepo["${netbox::directory}"]
  }

  file { 'expect script':
    ensure  => present,
    content => epp("${module_name}/expect.sh.epp"),
    path    => "${netbox::directory}/expect.sh",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Vcsrepo["${netbox::directory}"]
  }

  exec { 'installation':
    command => "/usr/bin/expect ${netbox::directory}/expect.sh",
    require => [ File['install script'], File['expect script'] ]
  }
}
