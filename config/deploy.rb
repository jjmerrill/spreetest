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
 
set :domain, "rails.example.com"
role :web, "50.56.240.217"                          # Your HTTP server, Apache/etc
role :app, "50.56.240.217"                          # This may be the same as your `Web` server
role :db,  "50.56.240.217", :primary => true        # This is where Rails migrations will run
#role :db,  "your slave db-server here"

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
end