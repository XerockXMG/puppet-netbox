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

}
