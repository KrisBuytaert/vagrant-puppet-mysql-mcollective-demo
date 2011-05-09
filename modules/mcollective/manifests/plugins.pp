class mcollective::plugins {

  case $operatingsystem {
    debian,ubuntu: { $p_base = "/usr/share/mcollective/plugins/mcollective" }
    redhat,centos: { $p_base = "/usr/libexec/mcollective/mcollective" }
  }
  $s_base = "puppet:///modules/mcollective/plugins"

  File {
    owner => root, group => root, mode  => 0444,
    require => Class["mcollective::install"],
    notify => Service["mcollective"],
  }

  file { "${p_base}/facts/facter.rb": source => "${s_base}/facts/facter/facter.rb" }
  file { "${p_base}/agent/service.rb": source => "${s_base}/agent/service/puppet-service.rb" }
  file { "${p_base}/agent/package.rb": source => "${s_base}/agent/package/puppet-package.rb" }
  file { "${p_base}/agent/nrpe.rb": source => "${s_base}/agent/nrpe/nrpe.rb" }
  file { "${p_base}/agent/puppetd.rb": source => "${s_base}/agent/puppetd/puppetd.rb" }
  file { "${p_base}/agent/filemgr.rb": source => "${s_base}/agent/filemgr/filemgr.rb" }
  file { "${p_base}/facts/mysql.rb": source => "${s_base}/facts/facter/mysql.rb" }
  file { "${p_base}/facts/facter_facts.rb": source => "${s_base}/facts/facter/facter_facts.rb" }
}
