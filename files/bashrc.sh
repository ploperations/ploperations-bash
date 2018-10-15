# Ensure /etc/bashrc is loaded in bash if it exists.
#
# The ensures that PS1 is set to a reasonable default on CentOS.
#
# On Debian, /etc/bash.bashrc is already loaded by /etc/profile, but
# /etc/bashrc doesn't exist, so this is a no-op.
#
# On OS X, /etc/profile.d isn't searched.
#
# On Solaris, /etc/profile.d isn't searched, and /etc/bashrc doesn't exist.

if [ "$PS1" -a -n "$BASH" -a "$BASH" != "/bin/sh" -a -r /etc/bashrc ]; then
  source /etc/bashrc
fi
