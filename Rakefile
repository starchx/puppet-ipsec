require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet_blacksmith/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-strings/tasks'

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.log_format = '%{path}:%{line}:%{check}:%{KIND}:%{message}'
  config.fail_on_warnings = true
  config.ignore_paths = [
    'test/**/*.pp',
    'vendor/**/*.pp',
    'examples/**/*.pp',
    'spec/**/*.pp',
    'pkg/**/*.pp'
  ]
  config.disable_checks = []
end

# Build and release will be handled by Travis-CI deploy stage
Blacksmith::RakeTask.new do |t|
  t.build = false
end

begin
  require 'github_changelog_generator/task'
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    version = (Blacksmith::Modulefile.new).version
    config.future_release = "v#{version}" if version =~ /^\d+\.\d+.\d+$/
    config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file."
    config.exclude_labels = %w{blacksmith duplicate question invalid wontfix wont-fix modulesync skip-changelog}
  end
rescue LoadError
end
