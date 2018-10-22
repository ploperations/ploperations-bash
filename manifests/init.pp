# install and configure bash
class bash (
  $bashpackage           = $bash::params::bashpackage,
  $bashcompletionpackage = $bash::params::bashcompletionpackage,
  $bashpath              = $bash::params::bashpath,
  $root_home             = $bash::params::root_home,
  $ensure                = latest,
) inherits bash::params {

  # Set the root prompt color based on stage.
  #   - prod nodes get red
  #   - test/stage nodes get blue
  #   - dev nodes get green
  #   - anything we can't determine gets red (assume prod)
  $prompt_color = $facts['classification']['stage'] ? {
    'prod'         => '\[\033[31m\]',
    /(test|stage)/ => '\[\033[36m\]',
    /(aws)?dev/    => '\[\033[32m\]',
    default        => '\[\033[31m\]',
  }

  if $bashpackage {
    package { $bashpackage:
      ensure => $ensure,
      alias  => 'bash',
    }
  }
  if $bashcompletionpackage {
    package { $bashcompletionpackage:
      ensure => $ensure,
    }
  }

  file {
    default:
      ensure => present,
      owner  => 'root',
      group  => '0',
      mode   => '0755',
    ;
    "${root_home}/.bashrc":
      content => template('bash/bashrc.erb'),
      mode    => '0750',
    ;
    '/etc/profile.d':
      ensure => 'directory',
    ;
    '/etc/profile.d/bashrc.sh':
      source => 'puppet:///modules/bash/bashrc.sh'
    ;
  }

  if $facts['os']['family'] == 'Solaris' {
    $profile_content = @("END")
      if [ -f ${root_home}/.bashrc ]; then
        . ${root_home}/.bashrc
      fi
      | END

    file { "${root_home}/.bash_profile":
      ensure  => 'present',
      owner   => 'root',
      group   => '0',
      mode    => '0755',
      content => $profile_content,
    }
  }
}
