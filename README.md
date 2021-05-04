# winterman

## Initial Setup

Download the latest release and update its package.

```
# (as root)
wget -qO - https://cesd.canyon.k12.ca.us/debian/public.key | apt-key add -
echo "deb https://cesd.canyon.k12.ca.us/debian buster main" > /etc/apt/sources.list.d/winterman.list
apt update
apt install winterman
```

## Build/Release

To build your own version, use `bazel build :winterman_deb`.  The package is
created as `bazel-bin/winterman__all.deb`.  Use `dpkg-name` to give it a proper
name.  A full release script is as follows:

```
#!/bin/bash
set -e

SRCDIR=$HOME/winterman
DSTDIR=/var/www/html/debian
SRCDEB=winterman__all.deb

cd $SRCDIR
git pull
bazel clean
bazel build :all
cd -

TMPDIR="$(mktemp -d)"
cp "${SRCDIR}"/bazel-bin/"${SRCDEB}" "${TMPDIR}/${SRCDEB}"
dpkg-name "${TMPDIR}/${SRCDEB}"
reprepro -b "${DSTDIR}" remove buster winterman
reprepro -b "${DSTDIR}" includedeb buster $(ls -1 "${TMPDIR}"/*.deb)
rm -rf "${TMPDIR}"
reprepro -b "${DSTDIR}" list buster
```

## SSH Gateway

The package establishes an autossh tunnel to `cesd`.  Add the following to your
to `~/.ssh/config` to automatically proxy.

```
host winterman
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null
        User winterman
        Hostname localhost
        Port 12222
        ProxyCommand ssh -p 22 winterman@cesd.canyon.k12.ca.us nc -w 30 %h %p
```

