#!/bin/zsh

find "$(dirname "$(basename $0)")"/config -type f | while read -r file; do
  cp ${file/.\/config/$HOME\/.config} $file
done

find "$(dirname "$(basename $0)")"/bin -type f | while read -r file; do
  cp ${file/.\/bin/$HOME\/.local\/bin} $file
done
