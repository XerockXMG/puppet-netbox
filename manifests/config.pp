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
}
