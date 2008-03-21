$:.unshift File.dirname(__FILE__) + '/../lib'

# IMPORTANT: sandbox must be loaded before rubygems!
require 'sandbox'
require 'rubygems'
require 'rack/adapter/sandboxed_rails'
require 'thin'

# FIXME autoload doesn't work for some reason...
require 'thin/connection'
require 'thin/request'
require 'thin/response'

Thin::Server.start '0.0.0.0', 3000 do
  map '/rails1' do
    run Rack::Adapter::SandboxedRails.new(:root => '/Users/marc/projects/thin/spec/rails_app', :prefix => '/rails1')
  end
  map '/rails2' do
    run Rack::Adapter::SandboxedRails.new(:root => '/Users/marc/projects/rails_app', :prefix => '/rails2')
  end
end
