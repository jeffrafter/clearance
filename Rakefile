require 'rake'
require 'rake/testtask'
require 'cucumber/rake/task'
require 'active_record'
 
test_files_pattern = 'test/rails_root/test/{unit,functional}/**/*_test.rb'

task :prepare => ['cleanup', 'generate', 'migrate']

Rake::TestTask.new(:test => :prepare) do |task|
  task.libs << 'lib'
  task.pattern = test_files_pattern
  task.verbose = false
end

Cucumber::Rake::Task.new(:features => :prepare) do |t|
  t.cucumber_opts = "--format pretty"
  t.feature_pattern = 'test/rails_root/features/*.feature'
end  

desc "Run the spec suite"
task :spec => :prepare do
  system "cd test/rails_root && rake spec"
end

desc "Run the test suite and features"
task :default => ['test', 'features', 'spec']


desc "Run the migrations inside the Rails root"
task :migrate do
  system "cd test/rails_root && rake db:migrate db:schema:dump db:test:prepare"
end

generators = %w(clearance clearance_features)

desc "Cleans up the test app before running the generator"
task :cleanup do
  generators.each do |generator|
    FileList["generators/#{generator}/templates/**/*.*"].each do |each|
      file = "test/rails_root/#{each.gsub("generators/#{generator}/templates/",'')}"
      File.delete(file) if File.exists?(file)
    end    
  end
  
  FileList["test/rails_root/db/**/*"].each do |each| 
    FileUtils.rm_rf(each)
  end
  FileUtils.rm_rf("test/rails_root/vendor/plugins/clearance")
  system "mkdir -p test/rails_root/vendor/plugins/clearance"
  system "cp -R generators test/rails_root/vendor/plugins/clearance"  
end

desc "Run the generator on the tests"
task :generate do
  generators.each do |generator|
    system "cd test/rails_root && ./script/generate #{generator}"
  end
  system "cd test/rails_root && ./script/generate clearance --rspec"
end

gem_spec = Gem::Specification.new do |gem_spec|
  gem_spec.name        = "clearance"
  gem_spec.version     = "0.4.4"
  gem_spec.summary     = "Rails authentication for developers who write tests."
  gem_spec.email       = "support@thoughtbot.com"
  gem_spec.homepage    = "http://github.com/thoughtbot/clearance"
  gem_spec.description = "Simple, complete Rails authentication scheme."
  gem_spec.authors     = ["thoughtbot, inc.", "Dan Croak", "Mike Burns", "Jason Morrison",
                          "Eugene Bolshakov", "Josh Nichols", "Mike Breen"]
  gem_spec.files       = FileList["[A-Z]*", "{generators,lib,shoulda_macros,rails}/**/*"]
end

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{gem_spec.name}.gemspec", 'w') do |f|
    f.write gem_spec.to_yaml
  end
end
