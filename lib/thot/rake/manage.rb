require 'rake'
require 'rubygems'
require 'thot'

$VERBOSE = nil
if Gem::Specification.respond_to?(:find_by_name)
  begin
    spec = Gem::Specification.find_by_name('thot')
    res = spec.lib_dirs_glob.split('/')
  rescue LoadError
    res = []
  end
else
  spec = Gem.searcher.find('carioca')
  res = Gem.searcher.lib_dirs_for(spec).split('/')
end

res.pop
tasks_path = res.join('/').concat('/lib/thot/rake/tasks/')
Dir["#{tasks_path}/*.task*"].each { |ext| load ext }