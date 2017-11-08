require 'bundler'

class App
  def self.name
    'DM4SEA'
  end

  def self.root
    File.expand_path('..', __dir__) + '/'
  end

  def self.env
    ENV['APP_ENVIRONMENT'] || 'development'
  end
end

Bundler.require(:default, App.env)

require_relative "environments/#{App.env}"
