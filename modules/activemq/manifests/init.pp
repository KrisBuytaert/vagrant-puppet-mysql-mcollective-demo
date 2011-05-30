class activemq {


    package {
	   	"java-1.6.0-openjdk":
                		alias  => "java",
                        	ensure => "installed";
	
                "activemq":
                        ensure => "installed",
                        require => [ Yumrepo["jpackage"],Yumrepo["puppetlabs"] ];
        }

   file {
	"/etc/activemq/activemq.xml":
  		source => "puppet:///modules/activemq/activemq.xml",
        require => Package["activemq"];

   }


   service {
	"activemq":
		enable => "true",
 		ensure  => running,
		require  => [ Package["activemq"],File["/etc/activemq/activemq.xml"]],
		
   }

}

