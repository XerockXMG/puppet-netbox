# = Class: netbox::install

class netbox::install {

  if $netbox::manage_python == true {

    package { lookup('netbox::python::packages'):
      ensure => 'installed',
    }

    class { 'python':
      version    => $netbox::python_version,
      pip        => 'present',
      dev        => 'present',
      virtualenv => 'present',
      gunicorn   => 'present',
    }
  }

  file { 'netbox dir':
    ensure => 'directory',
    path   => $netbox::directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

#  archive { "netbox-${::netbox::version}.tar.gz":
#    source          => "https://github.com/digitalocean/netbox/archive/v${::netbox::version}.tar.gz",
#    path            => "/tmp/netbox-${::netbox::version}.tar.gz",
#    extract_command => 'tar xzf %s --strip-components=1',
#    extract_path    => $::netbox::directory,
#    extract         => true,
#  }

  vcsrepo { '/opt/netbox/netbox':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/digitalocean/netbox.git',
    revision => $netbox::version,
    require  => File['netbox dir'],
  }
}
