require 'rack/sandbox'

module Rack
  module Adapter
    class SandboxedRails < Rack::Sandbox
      def initialize(options)
        super %{
          require 'rubygems'      
          require 'rack'
          require 'rack/adapter/rails'

          app = Rack::Adapter::Rails.new(#{options.inspect})
        }
      end
    end
  end
end