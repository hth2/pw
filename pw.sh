# this file should be sourced from .bashrc or its equivalent
# ref:
#   https://wiki.archlinux.org/index.php/Pacman/Rosetta
#   https://github.com/icy/pacapt

# exit if current shell is not bash
if [ ! -n "$BASH" ]; then
  return
fi

# return if PW_PACKAGE_MANAGER is already set (avoid duplicated loading)
if [[ -v PW_PACKAGE_MANAGER ]]; then
  return
fi

# PM detection (from lib/ansible/module_utils/facts/system/pkg_mgr.py)
# arg: <path> <format> <manager>
function set_pw_platform() {
  if [[ -x "$1" ]]; then
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
set_pw_platform /bin/opkg              not_set opkg
set_pw_platform /opt/bin/opkg          not_set opkg # on synology DS
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


# use sudo if availneeded and 
if [ "$EUID" -ne 0 ]; then
  SUDO=$(command -v sudo 2>/dev/null)
else
  SUDO=""
fi

run_cmd() {
  echo "$@"
  "$@"
}


pw_self_update() {
  run_cmd curl -L https://raw.githubusercontent.com/hth2/pw/master/pw.sh -o "$0"
}

# some common and fallback utils:
func_undefined()  { echo "$1" is undefined; exit 1; }

pw_install()      { func_undefined "${FUNCNAME[0]}"; } # DONE
pw_remove()       { func_undefined "${FUNCNAME[0]}"; }
pw_purge()        { func_undefined "${FUNCNAME[0]}"; }
pw_clean()        { func_undefined "${FUNCNAME[0]}"; }

pw_search()       { func_undefined "${FUNCNAME[0]}"; }
pw_search_desc()  { func_undefined "${FUNCNAME[0]}"; }
pw_search_file()  { func_undefined "${FUNCNAME[0]}"; }

pw_update()       { func_undefined "${FUNCNAME[0]}"; }
pw_upgrade()      { func_undefined "${FUNCNAME[0]}"; }

pw_source()       { func_undefined "${FUNCNAME[0]}"; }
pw_builddep()     { func_undefined "${FUNCNAME[0]}"; }
pw_download()     { func_undefined "${FUNCNAME[0]}"; }

pw_info()         { func_undefined "${FUNCNAME[0]}"; }
pw_file()         { func_undefined "${FUNCNAME[0]}"; }
pw_list()         { func_undefined "${FUNCNAME[0]}"; }
pw_own()          { func_undefined "${FUNCNAME[0]}"; }
pw_versions()     { func_undefined "${FUNCNAME[0]}"; }


case "$PW_PACKAGE_FORMAT" in
deb)
    pw_list()   { run_cmd dpkg-query -f '${binary:Package}\n' -W; }
    pw_info()   { run_cmd dpkg -p "$@"; }
    pw_file()   { run_cmd dpkg -L "$@"; }
    pw_own()    { run_cmd dpkg -S "$@"; }
    ;;

rpm)
    pw_info()   { run_cmd rpm -qi "$@";  }
    pw_file()   { run_cmd rpm -ql "$@";  }
    pw_list()   { run_cmd rpm -qa;       }
    pw_own()    { run_cmd rpm -qf "$@";  }
    ;;
esac

case "$PW_PACKAGE_MANAGER" in
apt)
    pw_install()       { run_cmd $SUDO apt-get install --no-install-recommends "$@"; }
    pw_remove()        { run_cmd $SUDO apt-get remove "$@"; }
    pw_purge()         { run_cmd $SUDO apt-get --purge autoremove "$@"; }
    pw_update()        { run_cmd $SUDO apt-get update; }
    pw_upgrade()       { run_cmd $SUDO apt-get update && apt-get dist-upgrade; }
    pw_clean()         { run_cmd $SUDO apt-get clean; }
    pw_info()          { run_cmd apt-cache show "$@"; }

    pw_search()        { run_cmd apt-cache search --names-only "$@"; }
    pw_search_desc()   { run_cmd apt-cache search "$@"; }
    pw_search_file()   { run_cmd apt-file search "$@"; }

    pw_source()        { run_cmd apt-get source "$@"; }
    pw_builddep()      { run_cmd apt-get build-dep "$@"; }
    pw_download()      { run_cmd apt-get install --download-only "$@"; }
    pw_versions()      { run_cmd apt-cache policy "$@"; }
    ;;

opkg)
# https://openwrt.org/docs/guide-user/additional-software/opkg
    pw_install()       { run_cmd $SUDO opkg install "$@"; }
    pw_remove()        { run_cmd $SUDO opkg remove "$@"; }
    pw_update()        { run_cmd $SUDO opkg update; }
    pw_list()          { run_cmd opkg list-installed; }
    pw_info()          { run_cmd opkg info "$@"; }
    pw_search()        { run_cmd opkg list | grep "$@"; }
    ;;


homebrew)
    pw_install()       { run_cmd brew install "$@"; }
    pw_remove()        { run_cmd brew remove "$@"; }
    pw_update()        { run_cmd brew update; }
    pw_upgrade()       { run_cmd brew upgrade "$@";  }
    pw_clean()         { run_cmd brew cleanup -s "$@";  }

    pw_search()        { run_cmd brew search --name "$@"; }
    pw_search_desc()   { run_cmd brew search --description "$@"; }

    pw_info()          { run_cmd brew info "$@"; }
    pw_file()          { run_cmd brew list --verbose "$@"; }
    pw_list()          { run_cmd brew list; }
    # https://stackoverflow.com/questions/19915683/how-to-find-package-for-installed-file-in-brew
    pw_own()           { run_cmd greadlink -f "$@"; } 
    ;;

zypper)
    pw_install()       { run_cmd zypper install "$@"; }
    pw_remove()        { run_cmd zypper remove "$@"; }
    pw_update()        { run_cmd zypper refresh; }
    pw_upgrade()       { run_cmd zypper update; }
    pw_clean()         { run_cmd zypper clean; }

    pw_search()        { run_cmd zypper search "$@"; }
    pw_search_desc()   { run_cmd zypper search "$@"; }

    pw_source()        { run_cmd zypper source-install "$@"; }
    pw_builddep()      { run_cmd zypper source-install -d "$@"; }
    pw_download()      { run_cmd zypper --download-only "$@"; }
    ;;


*)
    echo "Error: 'PW_PACKAGE_MANAGER' is not supported yet!"
    exit 1
esac



alias pw-self-update='pw_self_update'
alias pw-install='pw_install'
alias pw-remove='pw_remove'
alias pw-purge='pw_purge'
alias pw-file='pw_file'
alias pw-info='pw_info'
alias pw-list='pw_list'
alias pw-own='pw_own'
alias pw-search='pw_search'
alias pw-search-desc='pw_search_desc'
alias pw-search-file='pw_search_file'
alias pw-update='pw_update'
alias pw-upgrade='pw_upgrade'
alias pw-source='pw_source'
alias pw-builddep='pw_builddep'
alias pw-versions='pw_versions'
