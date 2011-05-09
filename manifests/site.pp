class repo {
    $releasever = "5"


    yumrepo {
        
        "epel":
            descr 	=> "Epel-5",
            baseurl 	=> "http://mirror.eurid.eu/epel/5/$hardwaremodel/",
            enabled 	=> 1,
            gpgcheck 	=> 0;
	"puppetlabs":
            descr 	=> "Puppetlabs",
            baseurl 	=> "http://yum.puppetlabs.com/",
            enabled 	=> 1,
            gpgcheck 	=> 0;

	"jpackage-generic":
 		baseurl => "http://mirrors.dotsrc.org/jpackage/5.0/generic/free/",
	     descr 	=> "JPackage-generic",
	    gpgcheck 	=> 0,
            enabled 	=> 1;

	"jpackage":
 		baseurl => "http://mirrors.dotsrc.org/jpackage/5.0/redhat-el-5.0/free/",
		descr   => "Jpackage-el5",	
	   	gpgcheck => 0,	
            	enabled 	=> 1;
	  


        }

}

class demo-mysql-databases {

 mysql::rights{"Set rights for puppet database":
  ensure   => present,
  database => "puppet",
  user     => "puppet",
  password => "puppet"
 }

 mysql::database{"mydb":
  ensure   => present
 }

 mysql::database{"testeke":
  ensure   => present
 }


}

class defaults {

	service { "iptables":
		ensure => stopped;
		}

    	include repo
	

    file { "/home/vagrant/.my.cnf":
	
      #target => "/root/.my.cnf",
      #ensure => link, 
      ensure => present, 
      owner => vagrant,
      group => vagrant,
      mode => 600,
      require => Exec["Initialize MySQL server root password"];
    }

}


node mysql {

    $hostname = 'MDC-A'
    $mysql_user = 'root'
    $mysql_root_password = 'SARDINES'
    $mysql_serverid = 1
    $replicate_ignore_db = 'mysql,puppet_dashboard,puppet_dashboard_test' 


    include defaults
    include mysql::server
    include mysql::setrootpw
    include demo-mysql-databases 

    Class ["mysql::server"] -> Class["demo-mysql-databases"]
    
}


node mc_master {

	
	


    	include defaults
 	include activemq
	include mcollective 
    include mcollective::client



}


node mariadb {
    $mysql_user = 'root'
    $mysql_root_password = 'SARDINES'
    $mysql_serverid = 1
    $replicate_ignore_db= "mysql"
    include defaults
	include mcollective
    	include defaults

	include maria::repository
	include mysql::config 
	include mysql::setrootpw
	# We really need to set a rootpw ! 
	include maria::packages
    	include demo-mysql-databases 
}


node percona {
    $mysql_user = 'root'
    $mysql_root_password = 'SARDINES'
    $mysql_serverid = 2
	$replicate_ignore_db= "mysql"
    include defaults
	include mcollective
	include percona::repository
	include percona::packages 
    include demo-mysql-databases 
    include mysql::setrootpw
	include mysql::config 
	# We really need to set a rootpw ! 
    include demo-mysql-databases 
}

