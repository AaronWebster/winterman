#!/bin/sh
echo BUILD_TIMESTAMP "$(date +%Y%m%d.%s)"
echo BUILD_SCM_SHORT_HASH "$(git rev-parse --short HEAD)"
