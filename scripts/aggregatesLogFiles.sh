#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app
EXTENSION="csv"
RESULT_DIR="result"
PROCESSED_LOGS_DIR="processed"
RESULT_DIR="result"
AWK_SCRIPT="ex.awk"
while [[ $# -gt 1 ]]
do
    key="$1"
    case $key in
        -e|--extension)
        EXTENSION="$2"
        shift
        shift
        ;;
    esac
    case $key in
        -s|--script)
        AWK_SCRIPT="$2"
        shift
        shift
        ;;
    esac
done
echo "${EXTENSION}" dir= "${__dir}" file="${__file}" base="${__base}" root="${__root}"
[[ -e *.zip ]] && unzip -oq '*.zip' || echo There aren\'t new zip archives
logsDir="${__dir}"/TransportStateLogs
mkdir -p "${RESULT_DIR}"
mkdir -p "${PROCESSED_LOGS_DIR}"
for file in $(find "${logsDir}"/ -type f); do
   newName="${__dir}"/"${RESULT_DIR}"/"${file: -10}"
   filteredLog="${logsDir}"/"${file: -10}".log
   processedLog="${__dir}"/"${PROCESSED_LOGS_DIR}"/"${file: -10}".log
   echo New file name:"${newName}" file name:"${file}"
   sed -e '/UNKNOWN/d; s/\t/ /g; s/^ //g; s/\([А-Я]\{2\}\|[А-Я]\{2\}[0-9]\{3\}\) /\1/g' "${file}" > "${filteredLog}"
   awk -f "${__dir}"/"${AWK_SCRIPT}" "${filteredLog}" > "${newName}"."${EXTENSION}"
   echo Remove file: "${file}" Move file:"${filteredLog}"
   mv -f "${filteredLog}" "${processedLog}"
   rm -rf "${file}"
done
rm -rf *.zip
