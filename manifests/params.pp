# @summary Default parameter values
#
# Default parameter values
#
class bash::params {
  case $facts['kernel'] {
    'Linux': {
      $bashpackage           = 'bash'
      $bashcompletionpackage = 'bash-completion'
      $bashpath              = '/bin/bash'
    }
    'FreeBSD': {
      $bashpackage           = 'bash'
      $bashcompletionpackage = 'bash-completion'
      $bashpath              = '/usr/local/bin/bash'
    }
    'SunOS': {
      $bashpackage           = 'shell/bash'
      $bashcompletionpackage = undef
      $bashpath              = '/usr/bin/bash'
    }
    'Darwin': {
      $bashpackage           = undef
      $bashcompletionpackage = undef
      $bashpath              = undef
    }
    default: {
      fail("${facts['kernel']} not supported by this module")
    }
  }

  $root_home = $facts['kernel'] ? {
    'Darwin' => '/var/root',
    default  => '/root',
  }
}
