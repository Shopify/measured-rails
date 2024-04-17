require "bundler/gem_tasks"
require 'rake/testtask'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

task default: :test

desc 'Run the test suite'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "lib/**/*"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end
