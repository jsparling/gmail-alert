def run(cmd)
  puts "> #{cmd}"
  puts `#{cmd}`
  exit(1) unless $?.success?
end

branch_name = ARGV[0]

if(branch_name == 'master')
  puts "Are you crazy? You can't delete 'master'!"
  exit(1)
end

run("git branch -d #{branch_name}")
run("git push origin :#{branch_name}")
