# = Class: netbox::install

class netbox::install {

  if $netbox::manage_python == true {

    $python_packages = lookup("netbox::python.${netbox::python_version}.packages")
    $pip = lookup("netbox::python.${netbox::python_version}.pip_package")
    $pip_version = lookup("netbox::python.${netbox::python_version}.pip_version")
    package { $python_packages:
      ensure => 'installed',
    }

    package { "${pip}":
      ensure => 'installed',
    }

    exec { 'install pip packages':
      command => "/usr/bin/${pip_version} install -U -r ${netbox::directory}/requirements.txt"
    }

    if $netbox::use_gunicorn == true {

    package { 'gunicorn install':
      ensure   => 'installed',
      name     => 'gunicorn',
      provider => $pip_version
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
