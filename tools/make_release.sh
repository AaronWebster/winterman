#!/usr/bin/bash
set -e

BAZELDIR="${HOME}/winterman"
REPODIR="${HOME}/AaronWebster.github.io/debian"

TMPDIR="$(mktemp -d)"
DEB_SRC="${BAZELDIR}/bazel-bin/winterman__all.deb" 
DEB_DEST="${TMPDIR}"/winterman_"$(cat ${BAZELDIR}/bazel-bin/VERSION)"_all.deb
cp "${DEB_SRC}" "${DEB_DEST}"

reprepro -b "${REPODIR}" includedeb buster "${DEB_DEST}"

# rm -rf "${TMPDIR}"
