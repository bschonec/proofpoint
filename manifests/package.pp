# == Class: proofpoint::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'proofpoint::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Brian Schonecker <mailto:bschonec@gmail.com>
#
class proofpoint::package {

  #### Package management

  # set params: in operation
  if $proofpoint::ensure == 'present' {

    $package_ensure = $proofpoint::autoupgrade ? {
      true  => 'latest',
      false => 'present',
    }

  # set params: removal
  } else {
    $package_ensure = 'purged'
  }

  # action
  package { $proofpoint::params::package:
    ensure => $package_ensure,
  }

}
