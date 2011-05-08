class percona::repository {


 $releasever = "5"
 $basearch = $hardwaremodel
    yumrepo {



        "percona":
            descr       => "Percona",
            enabled     =>1,
            baseurl     => "http://repo.percona.com/centos/$releasever/os/$basearch/",
            gpgcheck    => 0;

	}

}

class percona::packages {

	package {
		"Percona-Server-server-51.$hardwaremodel":
            alias => "MySQL-server",
			ensure => "installed";
		"Percona-Server-client-51.$hardwaremodel":
            alias => "MySQL-client",
			ensure => "installed";		
	}

}

