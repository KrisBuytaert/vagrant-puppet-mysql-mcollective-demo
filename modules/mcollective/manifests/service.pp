class mcollective::service {
  case $operatingsystem {
    ubuntu,debian,redhat,centos: { include mcollective::service::actual }
    default: { notice("${hostname}: mcollective: module does not yet support $operatingsystem") }
  }
}

class mcollective::service::actual {

  include mcollective::install
  include mcollective::config
  include mcollective::plugins

  service { "mcollective":
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Class["mcollective::install"],
  }
}
