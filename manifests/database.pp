# = Class: netbox::database

class netbox::database {

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => $netbox::postgresql_version,
  }

  class { 'postgresql::server':
    psql_path => $netbox::psql_path
  }
  class { 'postgresql::lib::devel': }
  class { 'postgresql::lib::python': }

  postgresql::server::db { $netbox::db_database:
    password => postgresql_password($netbox::db_username, $netbox::db_password),
    user     => $netbox::db_username,
  }

  postgresql::server::database_grant { 'grant all':
    privilege => 'ALL',
    db        => $netbox::db_database,
    role      => $netbox::db_username,
  }

  postgresql_conn_validator { 'netbox':
    host        => $netbox::db_hostname,
    db_username => $netbox::db_username,
    db_password => $netbox::db_password,
    db_name     => $netbox::db_database,
    port        => $netbox::db_port,
  }
}
