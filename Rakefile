require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "version"
require 'rake/version_task'
require 'code_statistics'
require 'yard'
require 'yard/rake/yardoc_task.rb'
require 'rubocop/rake_task'

RuboCop::RakeTask.new


Rake::VersionTask.new

RSpec::Core::RakeTask.new(:spec)


task :default => :spec

YARD::Rake::YardocTask.new do |t|
    t.files   = [ 'lib/**/*.rb', '-', 'doc/**/*','spec/**/*_spec.rb']
    t.options += ['-o', "yardoc"]
end

YARD::Config.load_plugin('yard-rspec')

namespace :yardoc do
    task :clobber do
        rm_r "yardoc" rescue nil
        rm_r ".yardoc" rescue nil
        rm_r "pkg" rescue nil
    end
end
task :clobber => "yardoc:clobber"
