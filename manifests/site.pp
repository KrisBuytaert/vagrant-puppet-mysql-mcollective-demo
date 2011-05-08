class repo {
    $releasever = "5"
    $basearch = "i386"


    yumrepo {
        
        "epel":
            descr 	=> "Epel-5",
            baseurl 	=> "http://mirror.eurid.eu/epel/5/i386/",
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



node mysql {

    $hostname = 'MDC-A'
    $mysql_root_password = 'SARDINES'
    $mysql_serverid = 1
    $replicate_ignore_db = 'mysql,puppet_dashboard,puppet_dashboard_test' 


    include repo
    include mysql::server
    include demo-mysql-databases 

    Class["repo"] ->  Class ["mysql::server"] -> Class["demo-mysql-databases"]
    
}


node mc_master {

	package { 
		"java-1.4.2-gcj-compat":
		ensure => absent;
	}
	
	


    	include repo
 	include activemq
	include mcollective 
        include mcollective::client



}


node mariadb {
    	include repo
	include mcollective
	include maria::repository
	include maria::packages
}


node percona {
    	include repo
	include mcollective
	include percona::repository
	include percona::packages 
}

