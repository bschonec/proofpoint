# == Class: proofpoint
#
# This class is able to install or remove proofpoint on a node.
#
# [Add description - What does this module do on a node?]
#
# === Parameters
#@param client_id
#  TODO
#
#@param client_secret
#  TODO
#
#@param relayuser_name
#  TODO
#
#@param relayuser_password
#  TODO
#
#@param fromaddress
#  The email address that shows up in FROM: header.
#
#@param toaddress
#  The REPLY-TO: address
#
#@param listeners
#  A Hash of listeners
#
#@param package_name
#  The name of the RPM package to be installed.
#
#@param service_name
#  The name of the service to be managed.
#
#@param package_ensure
#  Whether or not to install the package.
#
#@param service_ensure
#  Ensure the client is started/stopped/running, etc.
#
#@param service_enable
#  Enable the client on reboot.  true/false
#
#@param storebounces
#  Should bounced email be stored locally for future reference?
#
#@param storebounces_path
#  The path where bounded email will be stored locally.
#
#@param forwardemail
#  TODO
#
#@param tlsmode
#  TODO
#
# === Authors
#
# * Brian Schonecker <mailto:bschonec@gmail.com>
class proofpoint (
  String[1]                   $client_id,
  String[1]                   $client_secret,
  String[1]                   $relayuser_name,
  String[1]                   $relayuser_password,
  String  $fromaddress = 'from-nobody@example.com',
  String  $toaddress   = 'to-nobody@example.com',
  Array[Hash] $listeners = [
    { 'port' => 25,  'type' => 'SMTP' },
    { 'port' => 587, 'type' => 'SMTP' },
    { 'port' => 465, 'type' => 'SMTP' },
  ],
  Boolean $storebounces   = true,
  String  $storebounces_path     = '/var/spool/cmgw/nondeliver',
  Boolean $forwardemail   = true,
  String  $tlsmode     = 'forced TLS',
  String[1]                   $package_name   = 'ser-connector',
  String[1]                   $service_name   = 'ser-connector',
  Enum['absent', 'installed'] $package_ensure = 'installed',
  Enum['running', 'stopped']  $service_ensure = 'running',
  Boolean                     $service_enable = true,
) {
  package { $package_name:
    ensure => $package_ensure,
  }

  file { '/opt/ser/config/config.yaml':
    ensure  => file,
    content => template('proofpoint/config.yaml.erb'),
    owner   => $package_name,
    group   => 'root',
    mode    => '0644',
    before  => Service[$service_name],
    require => Package[$package_name],
    notify  => Service[$service_name],
  }

  service { $service_name:
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => Package[$package_name],
  }
}
