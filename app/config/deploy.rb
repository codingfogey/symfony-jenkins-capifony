set :stages,        %w(production staging)
set :default_stage, "staging"
set :stage_dir,     "app/config"
require 'capistrano/ext/multistage'

set :application, "symfony-codingfogey"
set :deploy_to,   "/var/www/#{application}"
set :app_path,    "app"

set :repository,  "ssh://localhost/var/git/#{application}.git"
set :scm,         :git

set :model_manager, "doctrine"

set  :use_sudo,             false
set  :keep_releases,        3
after "deploy",             "deploy:cleanup"

set :use_composer,          true
set :composer_options,      "--no-dev --verbose --prefer-dist --optimize-autoloader"

set :writable_dirs,         [app_path + "/cache", app_path + "/logs"]
set :shared_children,       []
set :webserver_user,        "www-data"
set :permission_method,     :acl
set :use_set_permissions,   true
set :user,                  "jenkins"
set :group,                 "www-data"
set :interactive_mode,      false
set :clear_controllers,     false

before 'symfony:composer:install', 'composer:copy_vendors'
before 'symfony:composer:update', 'composer:copy_vendors'

namespace :composer do
  task :copy_vendors, :except => { :no_release => true } do
    capifony_pretty_print "--> Copy vendor file from previous release"

    run "vendorDir=#{current_path}/vendor; if [ -d $vendorDir ] || [ -h $vendorDir ]; then cp -a $vendorDir #{latest_release}/vendor; fi;"
    capifony_puts_ok
  end
end

# Be more verbose by uncommenting the following line
# logger.level = Logger::MAX_LEVEL
