#!/bin/sh
ruby build.rb groovy_dev > bin/groovy_dev/dq.sh
ruby build.rb ruby_dev > bin/ruby_dev/dq.sh
ruby build.rb scala_dev > bin/scala_dev/dq.sh
ruby build.rb java_dev > bin/java_dev/dq.sh
ruby build.rb db > bin/db/dq.sh
ruby build.rb core > bin/core/dq.sh
ruby build.rb clojure_dev > bin/clojure_dev/dq.sh
ruby build.rb all > bin/all/dq.sh
ruby build.rb frontend_dev > bin/frontend_dev/dq.sh