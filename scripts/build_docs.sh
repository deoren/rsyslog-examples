#!/bin/bash

# Small bash script to generate html & epub versions of documentation from the current branch. The
# idea is to tag the generated files with the latest commit on the branch to allow me to easily
# determine what version of the "master" or "test" branch I'm working from.

# Pull details dynamically
version=$(grep -E '^version' source/conf.py | sed "s/'//g")
datestamp=$(date '+%Y%m%d')
commit=$(git describe | awk -F'-' '{print $NF}')
release="${version}.${datestamp}.${commit}"

declare -a formats
formats=(
  epub
  html
)

for format in "${formats[@]}"
do
    sphinx-build -D version="$version" -D release="$release" -b $format source build
done
