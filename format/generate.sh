#!/bin/sh
# Assumes CWD == $(dirname $0)

for i in *.proto
do
  protoc-c --c_out=../coder/ $i
done
