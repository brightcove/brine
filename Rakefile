# encoding: utf-8
require 'cucumber/rake/task'
Cucumber::Rake::Task.new

task :check do
  if (ENV['WATCH'])
    Kernel.system("bundle exec guard -c")
  else
    Rake::Task['cucumber'].invoke
  end
end

Cucumber::Rake::Task.new(:tutorial) do |t|
  ENV['ROOT_URL'] = 'https://api.myjson.com/'
  t.cucumber_opts = ['tutorial',
    '-r tutorial/support/env.rb']
end

task :help do
  puts """
Tasks
---
check - run tests

Environment Variables
---
WATCH - (guard) automatically rerun tests on file changes
"""
end
