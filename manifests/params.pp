# Class: mysql::params
#
#   The mysql configuration settings.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysql::params {

  $bind_address            = '127.0.0.1'
  $binlog_format           = 'UNSET'
  $config_template         = 'mysql/my.cnf.erb'
  $default_engine          = 'UNSET'
  $etc_root_password       = false
  $expire_logs_days        = 10
  $innodb_buffer_pool_size = 'UNSET'
  $innodb_file_per_table   = false
  $innodb_log_buffer_size  = 'UNSET'
  $innodb_log_file_size    = 'UNSET'
  $manage_service          = true
  $max_binlog_size         = 100M
  $old_root_password       = ''
  $package_ensure          = 'present'
  $purge_conf_dir          = false
  $port                    = 3306
  $root_password           = 'UNSET'
  $restart                 = true
  $server_id               = 'UNSET'
  $ssl                     = false

  case $::operatingsystem {
    'Ubuntu': {
      $service_provider = upstart
    }
    default: {
      $service_provider = undef
    }
  }

  case $::osfamily {
    'RedHat': {
      $basedir               = '/usr'
      $client_package_name   = 'mysql'
      $config_file           = '/etc/my.cnf'
      $datadir               = '/var/lib/mysql'
      $java_package_name     = 'mysql-connector-java'
      $log_error             = '/var/log/mysqld.log'
      $php_package_name      = 'php-mysql'
      $pidfile               = '/var/run/mysqld/mysqld.pid'
      $python_package_name   = 'MySQL-python'
      $root_group            = 'root'
      $ruby_package_name     = 'ruby-mysql'
      $ruby_package_provider = 'gem'
      $service_name          = 'mysqld'
      $server_package_name   = 'mysql-server'
      $socket                = '/var/lib/mysql/mysql.sock'
      $ssl_ca                = '/etc/mysql/cacert.pem'
      $ssl_cert              = '/etc/mysql/server-cert.pem'
      $ssl_key               = '/etc/mysql/server-key.pem'
    }

    'Suse': {
      $basedir               = '/usr'
      $datadir               = '/var/lib/mysql'
      $service_name          = 'mysql'
      $client_package_name   = $::operatingsystem ? {
        /OpenSuSE/           => 'mysql-community-server-client',
        /(SLES|SLED)/        => 'mysql-client',
        }
      $server_package_name   = $::operatingsystem ? {
        /OpenSuSE/           => 'mysql-community-server',
        /(SLES|SLED)/        => 'mysql',
        }
      $socket                = $::operatingsystem ? {
        /OpenSuSE/           => '/var/run/mysql/mysql.sock',
        /(SLES|SLED)/        => '/var/lib/mysql/mysql.sock',
        }
      $pidfile               = '/var/run/mysql/mysqld.pid'
      $config_file           = '/etc/my.cnf'
      $log_error             = $::operatingsystem ? {
        /OpenSuSE/           => '/var/log/mysql/mysqld.log',
        /(SLES|SLED)/        => '/var/log/mysqld.log',
        }
      $ruby_package_name     = $::operatingsystem ? {
        /OpenSuSE/           => 'rubygem-mysql',
        /(SLES|SLED)/        => 'ruby-mysql',
        }
      $python_package_name   = 'python-mysql'
      $java_package_name     = 'mysql-connector-java'
      $root_group            = 'root'
      $ssl_ca                = '/etc/mysql/cacert.pem'
      $ssl_cert              = '/etc/mysql/server-cert.pem'
      $ssl_key               = '/etc/mysql/server-key.pem'
    }

    'Debian': {
      $basedir              = '/usr'
      $datadir              = '/var/lib/mysql'
      $service_name         = 'mysql'
      $client_package_name  = 'mysql-client'
      $server_package_name  = 'mysql-server'
      $socket               = '/var/run/mysqld/mysqld.sock'
      $pidfile              = '/var/run/mysqld/mysqld.pid'
      $config_file          = '/etc/mysql/my.cnf'
      $log_bin              = '/var/log/mysql/mysql-bin.log'
      $log_error            = '/var/log/mysql/error.log'
      $ruby_package_name    = 'libmysql-ruby'
      $python_package_name  = 'python-mysqldb'
      $php_package_name     = 'php5-mysql'
      $java_package_name    = 'libmysql-java'
      $root_group           = 'root'
      $ssl_ca               = '/etc/mysql/cacert.pem'
      $ssl_cert             = '/etc/mysql/server-cert.pem'
      $ssl_key              = '/etc/mysql/server-key.pem'
    }

    'FreeBSD': {
      $basedir               = '/usr/local'
      $datadir               = '/var/db/mysql'
      $service_name          = 'mysql-server'
      $client_package_name   = 'databases/mysql55-client'
      $server_package_name   = 'databases/mysql55-server'
      $socket                = '/tmp/mysql.sock'
      $pidfile               = '/var/db/mysql/mysql.pid'
      $config_file           = '/var/db/mysql/my.cnf'
      $log_error             = "/var/db/mysql/${::hostname}.err"
      $ruby_package_name     = 'ruby-mysql'
      $ruby_package_provider = 'gem'
      $python_package_name   = 'databases/py-MySQLdb'
      $php_package_name      = 'php5-mysql'
      $java_package_name     = 'databases/mysql-connector-java'
      $root_group            = 'wheel'
      $ssl_ca                = undef
      $ssl_cert              = undef
      $ssl_key               = undef
    }

    default: {
      case $::operatingsystem {
        'Amazon': {
          $basedir               = '/usr'
          $datadir               = '/var/lib/mysql'
          $service_name          = 'mysqld'
          $client_package_name   = 'mysql'
          $server_package_name   = 'mysql-server'
          $socket                = '/var/lib/mysql/mysql.sock'
          $config_file           = '/etc/my.cnf'
          $log_error             = '/var/log/mysqld.log'
          $ruby_package_name     = 'ruby-mysql'
          $ruby_package_provider = 'gem'
          $python_package_name   = 'MySQL-python'
          $php_package_name      = 'php-mysql'
          $java_package_name     = 'mysql-connector-java'
          $root_group            = 'root'
          $ssl_ca                = '/etc/mysql/cacert.pem'
          $ssl_cert              = '/etc/mysql/server-cert.pem'
          $ssl_key               = '/etc/mysql/server-key.pem'
        }

        default: {
          fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat, Debian, and FreeBSD, or operatingsystem Amazon")
        }
      }
    }
  }

}
