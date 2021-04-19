require 'bundler/setup'
Bundler.require

class OpenAPIing < Sinatra::Base
    register Sinatra::R18n
      R18n::I18n.default = 'en'
        R18n.default_places { './i18n' }
end

require './my_app'
run MyApp
