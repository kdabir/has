# encoding: utf-8

# Usage:
# ruby build.rb <pattern1> <pattern2>... | bash
# valid patterns:
#   `dir_name/command_name`
#   `dir_name/*`
#   `*/command_name`
#   `*/*`
#
# dir/command name can be found in `lib/`
# do not include sh in command name
# pattern can contain commas to include multiple patterns

# debugging tip:
# use `.tap(&tap_it)` at any point in chain to print the values
# tap_it writes to `stderr`
# `ruby build.rb > /dev/null` to exclude the stdout of the script

def build *args
  tap_it = Proc.new { |it| $stderr.puts "tapped - #{it}" }
  content = args.collect { |it| it.split(',')}.flatten                        # comma seperated or multiple args
              .select { |pattern| File.fnmatch('lib/*/*.sh', "lib/#{pattern}.sh", File::FNM_PATHNAME)} # can potentially do ..
              .collect { |pattern| Dir["lib/#{pattern}.sh"] }.flatten.uniq    # get all files
              .sort { |x, y| File.basename(x) <=> File.basename(y) }          # sort alphabetically
              .collect { |file| File.read(file) }.join("\n")                  # concat

  [File.read("include/setup.sh"), content, File.read("include/report.sh")].join("\n")
end

puts build *ARGV unless ARGV.empty?
