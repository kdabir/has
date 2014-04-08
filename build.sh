#!/bin/sh

rm -rf ./bin

for group in groovy_dev ruby_dev scala_dev java_dev db core clojure_dev all frontend_dev; do
  mkdir -p ./bin/$group/
  ruby build.rb $group > ./bin/$group/dq.sh
done

find bin -type f -name \*.sh -exec chmod u+x {} +
