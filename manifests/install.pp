# = Class: netbox::install

class netbox::install {

  if $netbox::manage_python == true {

    $packages = lookup("netbox::python.${netbox::python_version}.packages")
    $pip = lookup("netbox::python.${netbox::python_version}.pip")
    package { ["$version"]  :
      ensure => 'installed',
    }

    package { "${pip}":
      ensure => 'installed',
    }

    if $netbox::use_gunicorn == true {

      if ($netbox::python_version > '27') or ($netbox::python_version == '3') {
        package { 'python3 gunicorn':
          ensure   => 'installed',
          provider => pip3,
          name     => 'gunicorn'
        }
      }
      if $netbox::pip_version == '27' {
        package { 'python2 gunicorn':
          ensure   => 'installed',
          provider => pip,
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

  $packages = lookup('netbox::packages')
  package { $packages:
    ensure => 'installed',
  }

  file { 'netbox dir':
    ensure => 'directory',
    path   => $netbox::directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  vcsrepo { "${netbox::directory}":
    ensure   => present,
    provider => git,
    source   => 'https://github.com/digitalocean/netbox.git',
    revision => $netbox::version,
    require  => File['netbox dir'],
  }
}
