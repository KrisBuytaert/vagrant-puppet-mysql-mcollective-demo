class mcollective::client {
    case $operatingsystem {
      ubuntu,debian,redhat,centos: { include mcollective::client::actual }
      default: { notice("${hostname}: mcollective: module does not yet support $operatingsystem") }
    }
}

class mcollective::client::actual {
  include mcollective::client::install
  include mcollective::client::plugins
  include mcollective::client::config
}

class mcollective::client::install {
  package { "mcollective-client": 
                ensure => present, 
                require => Class["repo"]
  }
}

class mcollective::client::config {

  file { "/etc/mcollective/client.cfg":
    content => template("mcollective/client.cfg.erb"),
    mode    => 0440, owner   => root,
    group   => $mcollective::client_group ? {
      "" => "root",
      default => $mcollective::client_group
    },
    require => Class["mcollective::client::install"]
  }
}

class mcollective::client::plugins {
  $bin_dir = "/usr/local/bin"
  $s_base = "puppet:///modules/mcollective/plugins"

  File {
    owner => root, group => root, mode  => 0555,
    require => Class["mcollective::client::install"],
  }

  file { "${bin_dir}/mc-service": source => "${s_base}/agent/service/mc-service" }
  file { "${bin_dir}/mc-package": source => "${s_base}/agent/package/mc-package" }
  file { "${bin_dir}/mc-nrpe":    source => "${s_base}/agent/nrpe/mc-nrpe" }
  file { "${bin_dir}/mc-puppetd": source => "${s_base}/agent/puppetd/mc-puppetd" }
  file { "${bin_dir}/mc-filemgr": source => "${s_base}/agent/filemgr/mc-filemgr" }
}
