#!/usr/bin/env bash
path=`pwd`
echo "${path}"

name="$1"
echo "${name}"

namelower=$(echo $name | awk '{print tolower($0)}')

#protoc --proto_path=${path} --cpp_out=${path} ${path}/${name}.proto
#protoc --proto_path=${path} --java_out=${path}/java ${path}/${name}.proto

protoc-261 --plugin=/usr/local/bin/protoc-gen-objc ${name}.proto --objc_out="./"


