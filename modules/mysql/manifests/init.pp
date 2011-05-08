# server.pp


class mysql::server  {

  include mysql::packages
  include mysql::config
  
  Class['mysql::packages'] -> Class['mysql::config'] 
  
}

class mysql::packages {

        package {
                "MySQL-client-community":
                        ensure => "installed";
                "MySQL-server-community":
                        ensure => "installed";
                "MySQL-shared-compat":
                        ensure => "installed";
        }
}


class mysql::config {

file {
	"/etc/my.cnf": 
		owner => "root",
 		group => "root",		
		ensure => file,
		content => template("mysql/my.cnf.erb"),
		notify => Service['mysql'];
        "/var/log/mysql/":
                ensure => "directory";
        "/var/lib/mysql/":
                ensure => "directory";
        "/var/lib/mysql/.tmp":
                ensure => "directory",
                owner => "mysql",
                group => 'mysql',
		require => Package['MySQL-client-community'];
}


service {
                "mysql":
                        enable  => true,
			ensure => running,
                        require => [Package['MySQL-server-community'],File['/var/lib/mysql/.tmp']];
        }

}


class mysql::setrootpw {





  $mysql_user = "root"
  file { "/root/.my.cnf":
      owner => root,
      group => root,
      mode => 600,
   require => Exec["Initialize MySQL server root password"]
    }


   exec { "Initialize MySQL server root password":
                unless  => "/usr/bin/test -f /root/.my.cnf",
                command => "/usr/bin/mysqladmin -u${mysql_user} password '${mysql_root_password}'",
                notify  => Exec["Generate my.cnf"],
                require =>  Service['mysql'] 
        }



  exec { "Generate my.cnf":
    command => "/bin/echo -e \"[mysql]\nuser=${mysql_user}\npassword=${mysql_root_password}\n[mysqladmin]\nuser=${mysql_user}\npassword=${mysql_root_password}\n[mysqldump]\nuser=${mysql_user}\npassword=${mysql_root_password}\n[mysqlshow]\nuser=${mysql_user}\npassword=${mysql_root_password}\n\" > /root/.my.cnf",
    refreshonly => true,
    creates => "/root/.my.cnf",
  }
}
