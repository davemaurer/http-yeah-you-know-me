require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = false
  t.warning = true
end

desc "Run tests"

task default: :test