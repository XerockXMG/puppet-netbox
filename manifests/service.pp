# = Class: netbox::service

class netbox::service {
  include ::nginx

  python::gunicorn { 'netbox':
    ensure      => present,
    bind        => "unix:${netbox::directory}/gunicorn.socket",
    dir         => "${netbox::directory}/netbox",
    appmodule   => 'netbox.wsgi:application',
    environment => 'production',
    mode        => 'wsgi',
    timeout     => 30,
  }

#  nginx::resource::vhost { $netbox::vhost:
#    proxy                => "http://unix:${netbox::directory}/gunicorn.socket",
#    server_name          => [ $::netbox::vhost, $::fqdn ],
#    location_cfg_prepend => {
#      'proxy_set_header X-Forwarded-Host'  => '$server_name',
#      'proxy_set_header X-Real-IP'         => '$remote_addr',
#      'proxy_set_header X-Forwarded-Proto' => '$scheme',
#    },
#  }

#  nginx::resource::location { "${netbox::vhost}-static":
#    ensure         => 'present',
#    location_alias => "${netbox::directory}/netbox/static",
#    vhost          => $netbox::vhost,
#    location       => '/static',
#  }

  nginx::resource::server { 'netbox server':
    listen_port => 80,
    proxy       => 'http://localhost:8000',
  }

  nginx::resource::location { 'netbox static':
    ensure   => present,
    server   => 'netbox server',
    www_root => '/opt/netbox/netbox/static/',
    location => '/static'
  }

  postgresql_conn_validator { 'netbox':
    db_name     => $netbox::db_database,
    host        => $netbox::db_hostname,
    db_username => $netbox::db_username,
    db_password => $netbox::db_password,
  }
}
