TMPFILE=$(mktemp)
sed -e 's/\s/=/' bazel-out/volatile-status.txt > "${TMPFILE}"
source "${TMPFILE}"
echo "${BUILD_TIMESTAMP}"-git"${BUILD_SCM_SHORT_HASH}"
rm "${TMPFILE}"
