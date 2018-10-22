# this file should be sourced from .bashrc or its equvivalent

# PM detection (from lib/ansible/module_utils/facts/system/pkg_mgr.py)
# arg: <path> <format> <manager>
function set_pw_platform() {
  if [ -x "$1" ]; then
    PW_PACKAGE_FORMAT="$2"
    PW_PACKAGE_MANAGER="$3"
  fi
}

# set_pw_platform   <path> <package-format> <package-manager>
# derived from https://github.com/ansible/ansible/blob/devel/lib/ansible/module_utils/facts/system/pkg_mgr.py

set_pw_platform /usr/bin/yum           rpm     yum
set_pw_platform /usr/bin/dnf           rpm     dnf
set_pw_platform /usr/bin/apt-get       deb     apt
set_pw_platform /usr/bin/zypper        rpm     zypper
# set_pw_platform /usr/sbin/urpmi        rpm     urpmi
# set_pw_platform /usr/bin/pacman        not_set pacman
# set_pw_platform /bin/opkg              not_set opkg
# set_pw_platform /usr/pkg/bin/pkgin     not_set pkgin
# set_pw_platform /opt/local/bin/pkgin   not_set pkgin
# set_pw_platform /opt/tools/bin/pkgin   not_set pkgin
# set_pw_platform /opt/local/bin/port    not_set macports
set_pw_platform /usr/local/bin/brew    not_set homebrew
# set_pw_platform /sbin/apk              not_set apk
# set_pw_platform /usr/sbin/pkg          not_set pkgng
# set_pw_platform /usr/sbin/swlist       not_set HP-UX
# set_pw_platform /usr/bin/emerge        not_set portage
# set_pw_platform /usr/sbin/pkgadd       not_set svr4pkg
# set_pw_platform /usr/bin/pkg           not_set pkg5
# set_pw_platform /usr/bin/xbps-install  not_set xbps
# set_pw_platform /usr/local/sbin/pkg    not_set pkgng
# set_pw_platform /usr/bin/swupd         not_set swupd
# set_pw_platform /usr/sbin/sorcery      not_set sorcery
# set_pw_platform /usr/bin/rpm-ostree    not_set atomic_container


# some common and fallback utils:
func_undefined()  { echo "$1" is undefined; exit 1; }

pw_install()      { func_undefined "$FUNCNAME"; }
pw_remove()       { func_undefined "$FUNCNAME"; }
pw_clean()        { func_undefined "$FUNCNAME"; }

pw_search()       { func_undefined "$FUNCNAME"; }
pw_search_desc()  { func_undefined "$FUNCNAME"; }
pw_search_file()  { func_undefined "$FUNCNAME"; }

pw_update()       { func_undefined "$FUNCNAME"; }
pw_upgrade()      { func_undefined "$FUNCNAME"; }

pw_source()       { func_undefined "$FUNCNAME"; }
pw_builddep()     { func_undefined "$FUNCNAME"; }
pw_download()     { func_undefined "$FUNCNAME"; }

pw_info()         { func_undefined "$FUNCNAME"; }
pw_check()        { func_undefined "$FUNCNAME"; }
pw_file()         { func_undefined "$FUNCNAME"; }
pw_list()         { func_undefined "$FUNCNAME"; }
pw_own()          { func_undefined "$FUNCNAME"; }

case "$PW_PACKAGE_FORMAT" in
deb)
    pw_list()   { dpkg-query -f '${binary:Package}\n' -W; }
    pw_info()   { dpkg -p "$@"; }
    pw_check()  { dpkg -s "$@"; }
    pw_file()   { dpkg -L "$@"; }
    pw_own()    { dpkg -S "$@"; }
    ;;

rpm)
    pw_info()   { rpm -qi "$@";  }
    pw_check()  { rpm -q "$@";   }
    pw_file()   { rpm -ql "$@";  }
    pw_list()   { rpm -qa;       }
    pw_own()    { rpm -qf "$@";  }
    ;;
esac

case "$PW_PACKAGE_MANAGER" in
apt)
    pw_update()        { apt-get update; }
    pw_upgrade()       { apt-get update; apt-get upgrade; }
    pw_install()       { apt-get install --no-install-recommends "$@"; }
    pw_clean()         { apt-get clean; }
    pw_remove()        { apt-get --purge purge "$@"; }

    pw_search()        { apt-cache search --names-only "$@"; }
    pw_search_desc()   { apt-cache search "$@"; }
    pw_search_file()   { apt-file search "$@"; }

    pw_source()        { apt-get source "$@"; }
    pw_builddep()      { apt-get build-dep "$@"; }
    pw_download()      { apt-get install --download-only "$@"; }
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
