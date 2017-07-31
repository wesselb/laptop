#!/usr/bin/env bash

set -e

cat extensions_map.txt | while read map
do
    ext=$(echo "$map" | sed -E 's/->(.*)$//g')
    app=$(echo "$map" | sed -E 's/^(.*)->//g')
    app_id=$(mdls -name kMDItemCFBundleIdentifier -r "/Applications/$app.app")
    /usr/local/bin/duti -s $app_id .$ext all
done