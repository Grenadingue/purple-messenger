#!/bin/sh

remote_dir="/data/local/tmp"
exe="$(basename "${1}")"

adb push "${1}" "${remote_dir}/${exe}"
adb shell "${remote_dir}/${exe}"
ret=${?}
adb shell "rm ${remote_dir}/${exe}"

exit ${ret}
