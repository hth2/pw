# this file should be sourced from .bashrc or its equvivalent

# PM detection (from lib/ansible/module_utils/facts/system/pkg_mgr.py)
# arg: <path> <format> <manager>
function set_pw_platform() {
  if [ -x "$1" ]; then
    PW_PACKAGE_FORMAT="$2"
    PW_PACKAGE_MANAGER="$3"
  fi
}

set_pw_platform   /usr/bin/yum          rpm    yum
set_pw_platform   /usr/bin/apt-get      deb    apt
set_pw_platform   /usr/local/bin/brew   none   homebrew

echo $PW_PACKAGE_FORMAT
echo $PW_PACKAGE_MANAGER

# some common and fallback utils:
pw_install()           { echo "$FUNCNAME not available!"; exit 1; }
pw_clean()             { echo "$FUNCNAME not available!"; exit 1; }
pw_remove()            { echo "$FUNCNAME not available!"; exit 1; }

pw_search()            { echo "$FUNCNAME not available!"; exit 1; }
pw_search_desc()       { echo "$FUNCNAME not available!"; exit 1; }
pw_search_file()       { echo "$FUNCNAME not available!"; exit 1; }

pw_update()            { echo "$FUNCNAME not available!"; exit 1; }
pw_upgrade()           { echo "$FUNCNAME not available!"; exit 1; }

pw_source()            { echo "$FUNCNAME not available!"; exit 1; }
pw_builddep()          { echo "$FUNCNAME not available!"; exit 1; }
pw_download()          { echo "$FUNCNAME not available!"; exit 1; }

pw_info()              { echo "$FUNCNAME not available!"; exit 1; }
pw_check()             { echo "$FUNCNAME not available!"; exit 1; }
pw_file()              { echo "$FUNCNAME not available!"; exit 1; }
pw_list()              { echo "$FUNCNAME not available!"; exit 1; }
pw_own()               { echo "$FUNCNAME not available!"; exit 1; }

case "$PW_PACKAGE_FORMAT" in
deb)
    pw_info()          { dpkg -p "$@"; }
    pw_check()         { dpkg -s "$@"; }
    pw_file()          { dpkg -L "$@"; }
    pw_own()           { dpkg -S "$@"; }
    ;;

rpm)
    pw_info()          { rpm -qi "$@"; }
    pw_check()         { rpm -q "$@"; }
    pw_file()          { rpm -ql "$@"; }
    pw_list()          { rpm -qa; }
    pw_own()           { rpm -qf "$@"; }
    ;;
esac

case "$PW_PACKAGE_MANAGER" in
apt)
    pw_list()          { apt list --installed "$@"; }
    pw_install()       { apt-get install "$@"; pw_clean; }
    pw_clean()         { apt-get clean; }
    pw_remove()        { apt-get --purge purge "$@"; }

    pw_search()        { apt-cache search --names-only "$@"; }
    pw_search_desc()   { apt-cache search "$@"; }
    pw_search_file()   { apt-file search "$@"; }

    # pw_update()        { apt-get update; touch /var/lib/apt/update_success; }
    # pw_upgrade()       { pw_update; apt-get upgrade; pw_clean; }

    pw_source()        { apt-get source "$@"; }
    pw_builddep()      { apt-get build-dep "$@"; }
    # pw_download()    is not implemented

    pw_info()          { apt-cache show "$@"; }
    # pw_check()       uses fallback
    # pw_file()        uses fallback
    # pw_list()        uses fallback
    # pw_own()         uses fallback
    ;;

*)
    echo "Error: 'PW_PACKAGE_MANAGER' is not supported yet!"
    exit 1
esac


alias pw-install='pw_install'
alias pw-remove='pw_remove'
alias pw-check='pw_check'
alias pw-file='pw_file'
alias pw-info='pw_info'
alias pw-list='pw_list'
alias pw-own='pw_own'
alias pw-search='pw_search'
alias pw-search_desc='pw_search_desc'
alias pw-search_file='pw_search_file'
alias pw-update='pw_update'
alias pw-upgrade='pw_upgrade'
alias pw-source='pw_source'
alias pw-builddep='pw_builddep'
