# config valid only for current version of Capistrano
#lock "3.8.2"
lock "3.11.0"

#set :application, "vertilux-accpac"
#set :repo_url, 'git@github.com:lepepe/vertilux-accpac.git'
#set :deploy_to, '/home/deploy/vertilux-accpac'

# whenever to schedule tasks
set :whenever_roles, ->{[:web]}

before "deploy:assets:precompile", "deploy:yarn_install"
before "deploy:restart", "sql_server:migrate"

namespace :deploy do
  desc 'Run rake yarn:install'
  task :yarn_install do
    on roles(:app, :web) do
      within release_path do
        execute("cd #{release_path} && yarn install")
      end
    end
  end
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app, :web), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

append :linked_files, "config/database.yml", "config/database_granite.yml", "config/database_reporting.yml", "config/database_postgres.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads", "public/json"
