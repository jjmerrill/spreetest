require 'bundler/capistrano'

set :application, "spreetest"
set :repository,  "git@github.com:jjmerrill/spreetest.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/var/local/#{application}"

set :deploy_via, :remote_cache
set :branch, "master"

set :passenger_conf, true
set :user, "app" # Login as?
set :runner, "app" # Run ./script as?
set :use_sudo, false

set :domain, "premier.designplusdevelopment.com"

role :web, "198.101.228.73"                          # Your HTTP server, Apache/etc
role :app, "198.101.228.73"                          # This may be the same as your `Web` server
role :db,  "198.101.228.73", :primary => true        # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :rails_env, "production"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "symlink the spree images"
  task :symlink_images, :roles => :app, :except => { :no_release => true } do
    run "rm -rf #{release_path}/public/spree"
    run "ln -nfs #{shared_path}/spree #{release_path}/public/spree"
  end

  desc "symlink the blog"
  task :symlink_blog, :roles => :app, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/blog #{release_path}/public/blog"
  end
end

after 'deploy:update_code', 'deploy:symlink_images'
after 'deploy:update_code', 'deploy:symlink_blog'