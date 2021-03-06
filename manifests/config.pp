# Class: mysql::config
#
# Parameters:
#   [*bind_address*]            - address to bind service.
#   [*binlog_format*]           - binary logging format
#   [*config_file*]             - my.cnf configuration file path.
#   [*datadir*]                 - path to datadir.
#   [*default_engine]           - configure a default table engine
#   [*etc_root_password*]       - whether to save /etc/my.cnf.
#   [*expire_logs_days*]        - no. of days for automatic binary log file removal
#   [*innodb_buffer_pool_size*] - size of the buffer pool
#   [*innodb_file_per_table*]   - whether to enable file-per-table mode
#   [*innodb_log_buffer_size*]  - size of the log file buffer
#   [*innodb_log_file_size*]    - size of the log file
#   [*log_bin*]                 - path to mysql binary log, if enabled by *server_id*
#   [*log_error]                - path to mysql error log
#   [*max_binlog_size*]         - maximum size of each binary log file
#   [*old_root_password*]       - previous root user password,
#   [*port*]                    - port to bind service.
#   [*restart]                  - whether to restart mysqld (true/false)
#   [*root_group]               - use specified group for root-owned files
#   [*root_password*]           - root user password.
#   [*server_id*]               - set server ID and enable binary logging
#   [*service_name*]            - mysql service name.
#   [*socket*]                  - mysql socket.
#   [*ssl]                      - enable ssl
#   [*ssl_ca]                   - path to ssl-ca
#   [*ssl_cert]                 - path to ssl-cert
#   [*ssl_key]                  - path to ssl-key
#
#
# Actions:
#
# Requires:
#
#   class mysql::server
#
# Usage:
#
#   class { 'mysql::config':
#     root_password => 'changeme',
#     bind_address  => $::ipaddress,
#   }
#
class mysql::config(
  $bind_address            = $mysql::bind_address,
  $binlog_format           = $mysql::binlog_format,
  $config_file             = $mysql::config_file,
  $datadir                 = $mysql::datadir,
  $default_engine          = $mysql::default_engine,
  $etc_root_password       = $mysql::etc_root_password,
  $expire_logs_days        = $mysql::params::expire_logs_days,
  $innodb_buffer_pool_size = $mysql::innodb_buffer_pool_size,
  $innodb_file_per_table   = $mysql::innodb_file_per_table,
  $innodb_log_buffer_size  = $mysql::innodb_log_buffer_size,
  $innodb_log_file_size    = $mysql::innodb_log_file_size,
  $max_binlog_size         = $mysql::params::max_binlog_size,
  $log_bin                 = $mysql::params::log_bin,
  $log_error               = $mysql::log_error,
  $pidfile                 = $mysql::pidfile,
  $port                    = $mysql::port,
  $purge_conf_dir          = $mysql::purge_conf_dir,
  $restart                 = $mysql::restart,
  $root_group              = $mysql::root_group,
  $root_password           = $mysql::root_password,
  $old_root_password       = $mysql::old_root_password,
  $server_id               = $mysql::params::server_id,
  $service_name            = $mysql::service_name,
  $socket                  = $mysql::socket,
  $ssl                     = $mysql::ssl,
  $ssl_ca                  = $mysql::ssl_ca,
  $ssl_cert                = $mysql::ssl_cert,
  $ssl_key                 = $mysql::ssl_key
) inherits mysql {

  File {
    owner  => 'root',
    group  => $root_group,
    mode   => '0400',
    notify    => $restart ? {
      true => Exec['mysqld-restart'],
      false => undef,
    },
  }

  if $ssl and $ssl_ca == undef {
    fail('The ssl_ca parameter is required when ssl is true')
  }

  if $ssl and $ssl_cert == undef {
    fail('The ssl_cert parameter is required when ssl is true')
  }

  if $ssl and $ssl_key == undef {
    fail('The ssl_key parameter is required when ssl is true')
  }

  # This kind of sucks, that I have to specify a difference resource for
  # restart.  the reason is that I need the service to be started before mods
  # to the config file which can cause a refresh
  exec { 'mysqld-restart':
    command     => "service ${service_name} restart",
    logoutput   => on_failure,
    refreshonly => true,
    path        => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
  }

  # manage root password if it is set
  if $root_password != 'UNSET' {
    case $old_root_password {
      '':      { $old_pw='' }
      default: { $old_pw="-p'${old_root_password}'" }
    }

    exec { 'set_mysql_rootpw':
      command   => "mysqladmin -u root ${old_pw} password '${root_password}'",
      logoutput => true,
      unless    => "mysqladmin -u root -p'${root_password}' status > /dev/null",
      path      => '/usr/local/sbin:/usr/bin:/usr/local/bin',
      notify    => $restart ? {
        true  => Exec['mysqld-restart'],
        false => undef,
      },
      require   => File['/etc/mysql/conf.d'],
    }

    file { '/root/.my.cnf':
      content => template('mysql/my.cnf.pass.erb'),
      require => Exec['set_mysql_rootpw'],
    }

    if $etc_root_password {
      file{ '/etc/my.cnf':
        content => template('mysql/my.cnf.pass.erb'),
        require => Exec['set_mysql_rootpw'],
      }
    }
  } else {
    file { '/root/.my.cnf':
      ensure  => present,
    }
  }

  file { '/etc/mysql':
    ensure => directory,
    mode   => '0755',
  }
  file { '/etc/mysql/conf.d':
    ensure  => directory,
    mode    => '0755',
    recurse => $purge_conf_dir,
    purge   => $purge_conf_dir,
  }
  file { $config_file:
    content => template('mysql/my.cnf.erb'),
    mode    => '0644',
  }

}
