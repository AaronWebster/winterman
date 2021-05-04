# winterman

## Adding

```
wget -qO - https://aaronwebster.github.io/debian/public.key | sudo apt-key add -
echo "deb https://aaronwebster.github.io/debian buster main" > /etc/apt/sources.list.d/winterman.list
```

## Build/Release
```
cd $HOME/winterman
git pull
bazel clean
bazel build :all
cd -
TMPDIR="$(mktemp -d)"
cp $HOME/winterman/bazel-bin/winterman__all.deb "${TMPDIR}/winterman__all.deb"
dpkg-name "${TMPDIR}/winterman__all.deb"
reprepro -b /var/www/html/debian remove buster winterman
reprepro -b /var/www/html/debian includedeb buster $(ls -1 "${TMPDIR}"/*.deb)
rm -rf "${TMPDIR}"
reprepro -b /var/www/html/debian list buster
```

## SSH Gateway

Add to `~/.ssh/config`:

```
host winterman
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null
        User winterman
        Hostname localhost
        Port 12222
        ProxyCommand ssh -p 22 winterman@cesd.canyon.k12.ca.us nc -w 30 %h %p
```

