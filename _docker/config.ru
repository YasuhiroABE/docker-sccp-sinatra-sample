require 'bundler/setup'
Bundler.require

use Rack::Protection
set :public_folder , File.dirname(__FILE__) + '/public'
set :static, true

require './my_app'
run MyApp

