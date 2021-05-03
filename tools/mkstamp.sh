#!/bin/sh
echo BUILD_DATE "$(date +%Y.%m.%d)"
echo BUILD_SCM_SHORT_HASH "$(git rev-parse --short HEAD)"
