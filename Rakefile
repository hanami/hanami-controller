# frozen_string_literal: true

require "rake"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "hanami/devtools/rake_tasks"

namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |task|
    file_list = FileList["spec/**/*_spec.rb"]
    file_list = file_list.exclude("spec/{integration,isolation}/**/*_spec.rb")

    task.pattern = file_list
  end
end

namespace :spec do
  desc "Run isolation tests"
  task :isolation do
    # Run each isolation test in its own Ruby process
    # Use with_unbundled_env to ensure bundler doesn't load extra gems
    Dir["spec/isolation/**/*_spec.rb"].each do |test_file|
      puts "\n\nRunning: #{test_file}"
      Bundler.with_unbundled_env do
        system("ruby #{test_file} --options spec/isolation/.rspec") || abort("Isolation test failed: #{test_file}")
      end
    end
  end

  desc "Run integration tests"
  task :integration do
    # Run each integration test with RSpec
    Dir["spec/integration/**/*_spec.rb"].each do |test_file|
      puts "\n\nRunning: #{test_file}"
      system("bundle exec rspec #{test_file}") || abort("Integration test failed: #{test_file}")
    end
  end
end

desc "Run all tests"
task test: ["spec:unit", "spec:isolation", "spec:integration"]

RuboCop::RakeTask.new(:rubocop)

desc "Run linting (alias for rubocop)"
task lint: :rubocop

task default: [:lint, :test]
