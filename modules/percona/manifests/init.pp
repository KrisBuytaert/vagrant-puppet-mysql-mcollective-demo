class percona::repository {


 $releasever = "5"
 $basearch = "i386"
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
		"Percona-Server-server-51":
			ensure => "installed";
		"Percona-Server-client-51":
			ensure => "installed";
		
	}

}

