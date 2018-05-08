# = Class: netbox

class netbox (
  String $python_version,
  Pattern[/v\d\.\d(\.\d-r\d|\.\d|-beta\d)/] $version,
  Pattern[/9\.\d|10/] $postgresql_version,
  Boolean $manage_python = true,
  $directory       = '/opt/netbox',
  $manage_database = true,
  String $psql_path = 'psql',
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
