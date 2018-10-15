class bash::params {

  case $::kernel {
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
      $bashpackage = 'shell/bash'
      $bashpath    = '/usr/bin/bash'
    }
  }

  $root_home = $::kernel ? {
    'Darwin' => '/var/root',
    default  => '/root',
  }
}
