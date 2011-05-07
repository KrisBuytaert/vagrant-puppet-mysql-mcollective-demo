class mcollective {

  $psk            = "unset"
  $stomp_user     = "mcollective"
  $stomp_password = "marionette"
  $stomp_host     = "cns-a"
  $stomp_port     = "6163"
  $factsource     = "facter"

  include mcollective::service
}
