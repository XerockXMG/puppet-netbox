# = Class: netbox::install

class netbox::install {

  if $netbox::manage_python == true {

    $packages = lookup('netbox::python_packages')
    package { $packages:
      ensure => 'installed',
    }

    if $netbox::use_gunicorn == true {
      class { 'python':
        version    => $netbox::python_version,
        pip        => 'present',
        dev        => 'present',
        virtualenv => 'present',
        gunicorn   => 'absent',
      }

      if $netbox::install_pip == true {
        package { 'python3 gunicorn':
          ensure   => 'installed',
          provider => pip3,
          name     => 'gunicorn'
        }
      }
    }
    else {
      class { 'python':
        version    => $netbox::python_version,
        pip        => 'present',
        dev        => 'present',
        virtualenv => 'present',
        gunicorn   => 'absent',
      }
    }
  }

  if $netbox::install_pip == true {
    package { "${netbox::python_version}-pip":
      ensure => 'installed',
    }
  }

  file { 'netbox dir':
    ensure => 'directory',
    path   => $netbox::directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  vcsrepo { '/opt/netbox/netbox':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/digitalocean/netbox.git',
    revision => $netbox::version,
    require  => File['netbox dir'],
  }
}
