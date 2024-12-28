#!/bin/bash

# based on https://raw.githubusercontent.com/eoli3n/archiso-zfs/master/init

set -e

verbose=0

function print () {
    echo -e "\n\033[1m> $1\033[0m"
}

init_archzfs () {
    if pacman -Sl archzfs >&3; then
        print "archzfs repo was already added"
        return 0
    fi
    print "Add archzfs repo"
    
    # Disable Sig check
    pacman -Syy archlinux-keyring --noconfirm >&3 || return 1
    pacman-key --populate archlinux >&3 || return 1
    pacman-key --recv-keys F75D9D76 >&3 || return 1
    pacman-key --lsign-key F75D9D76 >&3 || return 1
    cat >> /etc/pacman.conf <<"EOF"
[archzfs]
Server = http://archzfs.com/archzfs/x86_64
Server = http://mirror.sum7.eu/archlinux/archzfs/archzfs/x86_64
Server = https://mirror.biocrafting.net/archlinux/archzfs/archzfs/x86_64
EOF
    pacman -Sy >&3 || return 1
    return 0
}

init_archlinux_archive () {
# $1 is date formated as 'YYYY/MM/DD'
# Returns 1 if repo does not exists

    # Archlinux Archive workaround for 2022/02/01
    if [[ "$1" == "2022/02/01" ]]
    then
        version="2022/02/02"
    else
        version="$1"
    fi

    # Set repo
    repo="https://archive.archlinux.org/repos/$version/"

    # If repo exists, set it
    if curl -s "$repo" >&3
    then
        echo "Server=$repo\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
    else
        print "Repository $repo is not reachable or doesn't exist."
        return 1
    fi

    return 0
}

function init_archlinux_archive () {
    # $1 is date formated as 'YYYY/MM/DD'
    # Returns 1 if repo does not exists

    version="$1"

    # Set repo
    repo="https://archive.archlinux.org/repos/$version/"

    # If repo exists, set it
    if curl -s "$repo" >&3
    then
        echo "Server=$repo\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
    else
        print "Repository $repo is not reachable or doesn't exist."
        return 1
    fi

    return 0
}

function install_zfs_dkms () {
    print "Init Archlinux Archive repository"
    archiso_version=$(sed 's-\.-/-g' /version)
    init_archlinux_archive "$archiso_version" || return 1

    print "Download Archlinux Archives package lists and upgrade"
    pacman -Syyuu --noconfirm >&3 || return 1

    print "Install base-devel linux-headers git"
    pacman -S --noconfirm base-devel linux-headers git >&3 || return 1

    print "Install zfs-dkms"
    
    # Install package
    if pacman -S zfs-dkms --noconfirm >&3
    then
        zfs=1
    else
        return 1
    fi
    return 0
}

function main() {
    exec &> >(tee "debug.log")

    if [[ "$verbose" -gt 0 ]]
    then
        exec 3>&1
    else
        exec 3>/dev/null
    fi

    if ! grep -q 'arch.*iso' /proc/cmdline >&3
    then
        print "You are not running archiso, exiting."
        exit 1
    fi

    print "Increase cowspace to half of RAM"

    mount -o remount,size=50% /run/archiso/cowspace >&3

    init_archzfs || exit 1

    install_zfs_dkms || exit 1

    if [[ "$zfs" == "1" ]]
    then
        modprobe zfs && echo -e "\n\e[32mZFS is ready\n"
    else
        print "No ZFS module found"
        exit 1
    fi
}

main
