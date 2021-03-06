# pw
A simple wrapper for package managers written in bash.

pw aims to make use of different package managers easier by wrapping them to
a consistent interface.

## Install
* as root with curl:
```
curl -L https://raw.githubusercontent.com/hth2/pw/master/pw.sh -o /usr/local/bin/pw.sh
echo 'source /usr/local/bin/pw.sh' >> /etc/bash.bashrc
echo 'source /usr/local/bin/pw.sh' >> /etc/profile
```
* as root with wget:
```
wget https://raw.githubusercontent.com/hth2/pw/master/pw.sh -O /usr/local/bin/pw.sh
echo 'source /usr/local/bin/pw.sh' >> /etc/bash.bashrc
echo 'source /usr/local/bin/pw.sh' >> /etc/profile
```
* as root with wget:
```
wget https://raw.githubusercontent.com/hth2/pw/master/pw.sh -O /usr/local/bin/pw.sh
echo 'source /usr/local/bin/pw.sh' >> /etc/bash.bashrc
```
* as regular user:
```
curl -L https://raw.githubusercontent.com/hth2/pw/master/pw.sh -o ~/.pw.sh
echo 'source ~/.pw.sh' >> ~/.bashrc
```

## Update
* this command will try to fetch the latest version of pw.sh from github
```
pw-self-update
```


## Usage examples
Let's say we are on a debian-like system. Instead of running `apt-get` and the
likes, we would use the following commands (for most common tasks):

```
pw-update             # update package information by 'apt-get update'
pw-install vim        # install vim by 'apt-get install vim'
pw-remove vim         # uninstall vim by 'apt-get remove vim'
pw-uninstall vim      # ditto'
pw-search vim         # search for packages containing vim in name by 'apt-cache search --names-only abc'
pw-search-desc vim    # search for packages containing vim in description by 'apt-cache search abc'
pw-info vim           # show info about package vim by 'apt-cache show abc'
pw-file file          # show files installed by package vim by  'dpkg -L vim'
pw-own /usr/bin/pinky # show which package owns a particular file by 'dpkg -S /usr/bin/pink'
pw-list               # list all installed packages by 'apt list --installed'
```

What is the benefit of doing so, instead of using apt directly? For me the
benefits are:
* when I am on system with another package manager (yum, homebrew, zypper),
the above commands also work.
* Commands are easy to remember thanks to consistent, sensible naming: command like `pw-own /usr/bin/pinky` (which package owns file `/usr/bin/pinky`?) is easier to remember than `dpkg -S /usr/bin/pinky` (unless you like to read `man dpkg`)
* Commands are easy to type thanks to out-of-the-box auto-completion; no need to mess around with my bash/zsh setup. Just type e.g. `pw-<Tab>` to see all commands.
* Easy installation, so that when I need `pw`, it can by installed with a quick copy-and-paste action. I find this very convenient whenever I am inside a VPS or docker container and need to do something quickly.

## Links
* https://wiki.archlinux.org/index.php/Pacman/Rosetta
* original version: https://www.howtoforge.com/pkgwatch-a-package-management-wrapper
* https://github.com/icy/pacapt
