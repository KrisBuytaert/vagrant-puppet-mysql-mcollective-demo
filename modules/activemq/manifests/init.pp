class activemq {


    package {
                "java":
                        ensure => "installed";
                "activemq":
                        ensure => "installed";
        }

   file {
	"/etc/activemq/activemq.xml":
  		source => "puppet:///modules/activemq/activemq.xml";

   }


   service {
	"activemq":
		enable => "true",
 		ensure  => running,
		require  => [ Package["activemq"],File["/etc/activemq/activemq.xml"]],
		
   }

}

