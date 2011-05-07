class mcollective::config {

  case $operatingsystem {
    debian,ubuntu: { $libdir = "/usr/share/mcollective/plugins" }
    redhat,centos: { $libdir = "/usr/libexec/mcollective" }
  }

  File {
    owner => root,
    group => root,
    mode  => 0440,
    require => Class["mcollective::install"]
  }

  file { "/etc/mcollective":
    ensure => directory,
    mode  => 0750,
  }
  file { "/etc/mcollective/server.cfg":
    content => template("mcollective/server.cfg.erb"),
    notify  => Service["mcollective"]
  }
  file { "/etc/mcollective/facts.yaml":
    content => template("mcollective/facts.yaml.erb")
  }

  @file { "/etc/nagios/nrpe_conf.d/mcollective_touch_check.cfg":
    tag => "nagios_nrpe_check",
        ensure => absent,
  }

  #@nagios::nrpe_command { "check_mcollective_touch":
  #  command   => "check_file_age",
  #            parameters => "-w 600 -c 1200 /var/run/mcollective.plugin.filemgr.touch",
   #           cplugdir  => 'system'
  #}
}
