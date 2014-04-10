# Usage:
# ruby build.rb <group1> <group2>... | sh


groups = {
    :all => "*/*",
    :core => "core/*",
    :shell => "shell/*",
    :java_dev => ["core/java", "java/*"],
    :clojure_dev => ["core/java", "clojure/*"],
    :groovy_dev => ["core/java","java/gradle", "groovy/*"],
    :scala_dev => ["core/java", "scala/*"],
    :ruby_dev => ["core/ruby", "ruby/*"],
    :frontend_dev => ["core/*", "frontend/*"],
    :db => ["db/*"]
}

tap_it = Proc.new { |it| $stderr.puts "tapped - #{it}" }
# use `.tap(&tap_it)` at any point in chain to print the values
# tap_it writes to `stderr`
# `ruby build.rb > /dev/null` to exclude the stdout of the script

content =
    (ARGV.empty? ? ["core"] : ARGV)                                         # groups_to_load
    .collect { |group| groups[group.to_sym] }.flatten.compact               # patterns
    .collect { |pattern| Dir["lib/#{pattern}.sh"] }.flatten.uniq            # sh files
    .sort { |x, y| File.basename(x) <=> File.basename(y) }                  # sort, remove if you dont want
    .collect { |file| File.read(file) }.join("\n")                          # concat

puts [File.read("include/setup.sh"), content, File.read("include/report.sh")].join("\n")

