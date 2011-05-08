class mcollective {

  $psk            = "unset"
  $stomp_user     = "mcollective"
  $stomp_password = "marionette"
  $stomp_host     = "192.168.99.2"
  $stomp_port     = "6163"
  $factsource     = "facter"

  include mcollective::service
}
