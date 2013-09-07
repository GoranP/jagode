require 'bundler/capistrano'


server "strawberry.pbf.hr", :app, :web, :db, :primary => true

set :application, "jagode"
set :repository,  "https://github.com/GoranP/jagode.git"
set :scm, "git"
set :user, "goran"  # The server's user for deploys
set :rails_env, "production"

set :use_sudo, false

set :deploy_to, "/var/www/strawberry"

set :branch, "master"
set :deploy_via, :remote_cache

set :keep_releases, 5

#role :web, "nginx"                          # Your HTTP server, Apache/etc
#role :app, "passenger"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

default_run_options[:pty] = true 
set :ssh_options, { :forward_agent => true }

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end
