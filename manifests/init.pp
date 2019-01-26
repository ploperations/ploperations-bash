# @summary Install and configure bash
#
# Install and configure bash
#
# @example Basic usage
#   include bash
#
# @param bashpackage
#   The name of the package to be installed
# @param bashcompletionpackage
#   The name of the package that provides auto-completions for bash
# @param bashpath
#   The path to the bash binary once installed
# @param root_home
#   The path to root's home directory
# @param ensure
#   This value is passed directly to the package resouce for $bashpackage.
#   See here for valid values:
#   https://puppet.com/docs/puppet/latest/types/package.html#package-attribute-ensure
#
class bash (
  Optional[String[1]]            $bashpackage           = $bash::params::bashpackage,
  Optional[String[1]]            $bashcompletionpackage = $bash::params::bashcompletionpackage,
  Optional[Stdlib::Absolutepath] $bashpath              = $bash::params::bashpath,
  Stdlib::Absolutepath           $root_home             = $bash::params::root_home,
  $ensure                                               = latest,
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
