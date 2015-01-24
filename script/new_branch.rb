require 'optparse'

def run(cmd)
  puts "> #{cmd}"
  puts `#{cmd}`
  exit(1) unless $?.success?
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby script/new_branch.rb BRANCH [options]"

  opts.on("-c", "--current", "Use current branch") do |c|
    options[:current] = c
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

branch_name = ARGV[0]

run("git checkout master") unless options[:current]
run("git checkout -b #{branch_name}")
run("git config branch.#{branch_name}.remote origin")
run("git config branch.#{branch_name}.merge refs/heads/#{branch_name}")
run("git config branch.#{branch_name}.rebase true")
run("git push origin #{branch_name}:#{branch_name}")
