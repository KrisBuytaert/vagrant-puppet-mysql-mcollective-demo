class mcollective::install {
  case $operatingsystem {
    ubuntu,debian: { include mcollective::install::debian }
    redhat,centos: { include mcollective::install::redhat }
    default: { fail("${hostname}: mcollective: trying to install unsupported operatingsystem $operatingsystem") }
  }
}

class mcollective::install::redhat {

  package { "stomp":
    name => "rubygem-stomp",
    ensure => "installed"
  }

  package { "mcollective":
    ensure => present,
    require => Package["stomp"],
  }

}

class mcollective::install::debian {

  package { "stomp":
    provider => gem,
    ensure => "1.1",
  }

  package { "mcollective":
    ensure => present,
    require => Package["stomp"],
  }
}
