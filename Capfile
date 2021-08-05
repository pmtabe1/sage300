# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'
# Include tasks from other gems included in your Gemfile
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rbenv'
# whenever to create cron jobs
require "whenever/capistrano"

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.5.0'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
