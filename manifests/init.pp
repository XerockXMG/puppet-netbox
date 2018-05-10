# = Class: netbox

class netbox (
  Enum['2.7', '3', '3.4'] $python_version,
  String $allowed_hosts,
  String $secret_key,
  Pattern[/v\d\.\d(\.\d-r\d|\.\d|-beta\d)/] $version,
  Pattern[/9\.\d|10/] $postgresql_version,
  Boolean $manage_python = true,
  Boolean $use_gunicorn = true,
  String $pip_version = '3',
  $directory       = '/opt/netbox',
  $manage_database = true,
  String $psql_path = '/usr/bin/psql',
  $db_hostname     = '127.0.0.1',
  $db_database     = 'netbox',
  $db_username     = 'netbox',
  $db_password     = 'netbox',
  $db_port         = '5432',
) {
  contain 'netbox::install'
  contain 'netbox::config'
  contain 'netbox::service'

  if $manage_database {
    contain 'netbox::database'

    Class['netbox::database'] -> Class['netbox::config']
  }

  Class['netbox::install'] -> Class['netbox::config'] ~> Class['netbox::service']
}
