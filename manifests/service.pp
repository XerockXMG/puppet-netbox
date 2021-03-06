# = Class: netbox::service

class netbox::service {
  include ::nginx

  if $netbox::use_gunicorn == true {

    python::gunicorn { 'netbox gunicorn':
      ensure      => present,
      name        => 'gunicorn_config.py',
      bind        => "unix:${netbox::directory}/gunicorn.socket",
      config_dir  => "${netbox::directory}",
      dir         => "${netbox::directory}/netbox",
      appmodule   => 'netbox.wsgi:application',
      environment => 'production',
      mode        => 'wsgi',
      timeout     => 30,
      owner       => 'nginx',
      group       => 'nginx',
      template    => 'netbox/gunicorn.erb',
    }

    supervisord::program { 'supervisor-netbox':
    command   => 'gunicorn -c /opt/netbox/gunicorn_config.py netbox.wsgi',
    directory => '/opt/netbox/netbox/',
    user      => 'nginx'
    }
  }

  nginx::resource::server { "$netbox::webserver_name":
    listen_port => 80,
    proxy       => "http://localhost:${netbox::port}",
  }

  nginx::resource::location { 'netbox static':
    ensure   => present,
    server   => "$netbox::webserver_name",
    www_root => '/opt/netbox/netbox/',
    location => '/static/'
  }

}
