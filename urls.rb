Dir["bin/**/*.sh"].each { |file|
  puts "#### " + File.dirname(file).gsub("bin/", "").gsub("_", " ")
  puts "`curl -sL https://raw.github.com/kdabir/dq/master/#{file} | sh`"
}
