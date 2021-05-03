# winterman

## Adding

```
wget -qO - https://aaronwebster.github.io/debian/public.key | sudo apt-key add -
echo "deb https://aaronwebster.github.io/debian buster main" > /etc/apt/sources.list.d/winterman.list
```

## Build/Release
```
bazel build :winterman_deb
dpkg-name bazel-bin/winterman__all.deb
reprepro -b $REPODIR includedeb buster $DEBFILE
```

