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

	"jpackage":
	     baseurl    => "http://sunsite.rediris.es/mirror/jpackage/5.0/redhat-el-5.0/free/",
	     descr 	=> "JPackage",
#	     mirrorlist => "http://www.jpackage.org/mirrorlist.php?dist=redhat-el-5.0&type=free&release=5.0",
	    gpgcheck 	=> 0,
            enabled 	=> 1,


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
	
	


    	include repo
 	include activemq
        include mcollective::client
	include mcollective 



}


node mariadb {
    	include repo
	include mcollective
}


node percona {
    	include repo
	include mcollective

}

