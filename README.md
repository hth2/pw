# pw
A simple wrapper for package managers written in bash.

pw aims to make use of different package managers easier by wrapping them to
a consistent interface.

## Install
* as root:
```
curl -L https://raw.githubusercontent.com/hth2/pw/master/pw.sh -o /usr/local/bin/pw.sh
echo 'source /usr/local/bin/pw.sh' >> ~/.bashrc
```
* as regular user:
```
curl -L https://raw.githubusercontent.com/hth2/pw/master/pw.sh -o ~/.pw.sh
echo 'source ~/.pw.sh' >> ~/.bashrc
```

## Usage examples
Let's say we are on a debian-like system. Instead of running `apt-get` and the
likes, we would use the following commands (for most common tasks):

```
pw-update             # update package information by 'apt-get update'
pw-install vim        # install vim by 'apt-get install vim'
pw-remove vim         # uninstall vim by 'apt-get remove vim'
pw-uninstall vim      # ditto'
pw-search vim         # search for packages containing vim in name by
                      # 'apt-cache search --names-only abc'
pw-search-desc vim    # search for packages containing vim in description by
                      # run 'apt-cache search abc'
pw-info vim           # show info about package vim by 'apt-cache show abc'
pw-file file          # show files installed by package vim by  'dpkg -L vim'
pw-own /usr/bin/pinky # show which package owns a particular file by 'dpkg -S /usr/bin/pink'
pw-list               # list all installed packages by 'apt list --installed'
```

What is the benefit of doing so, instead of using apt directly? For me the
benefits are:
* when I am on system with another package manager (yum, homebrew, zypper),
the above commands also work
* command like `pw-own /usr/bin/pinky` (which package owns file `/usr/bin/pinky`?) is easier to remember than `dpkg -S /usr/bin/pinky` (unless you like to read `man dpkg`)
