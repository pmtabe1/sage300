namespace :sql_server do
  desc 'SQL Server migrattion'
  task :migrate do
    on roles(:web) do
      # Legacy migration used for SQL server.
      #execute("cd #{release_path} && RAILS_ENV=#{fetch(:stage)} $HOME/.rbenv/bin/rbenv exec bundle exec rake sqlserver:db:migrate")
      execute("cd #{release_path} && RAILS_ENV=#{fetch(:stage)} $HOME/.rbenv/bin/rbenv exec bundle exec rake db:migrate")
    end
  end
end
