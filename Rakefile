require 'rake/testtask'

Rake::TestTask.new

task :build do
  sh 'bundle exec bgem'
end

task :default => [:build, :test]
