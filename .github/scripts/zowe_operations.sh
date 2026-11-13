#!/usr/bin/env bash
set -euo pipefail

# Validate required environment variables
: "${ZOWE_USERNAME:?ZOWE_USERNAME is required}"
: "${ZOWE_PASSWORD:?ZOWE_PASSWORD is required}"

LOWERCASE_USERNAME="${ZOWE_USERNAME,,}"
TARGET_DIR="/z/${LOWERCASE_USERNAME}/cobolcheck"

echo "Using target directory: ${TARGET_DIR}"

if ! zowe zos-files list uss-files "${TARGET_DIR}" >/dev/null 2>&1; then
  echo "Directory does not exist. Creating it..."
  zowe zos-files create uss-directory "${TARGET_DIR}"
else
  echo "Directory already exists."
fi

echo "Uploading COBOL Check files..."
zowe zos-files upload dir-to-uss "./cobol-check" "${TARGET_DIR}" --recursive --binary-files "cobol-check-0.2.9.jar"

echo "Verifying upload:"
zowe zos-files list uss-files "${TARGET_DIR}"
