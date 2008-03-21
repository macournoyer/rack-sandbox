require 'sandbox'
require 'sandbox/marshal'

module Rack
  class Sandbox
    def initialize(eval_code)
      @box = ::Sandbox.new(:init => :all)
    
      copy_globals
      copy_env
    
      # Load the adapter inside the sandbox
      @box.eval %{
        require 'sandbox/binding'
        require 'sandbox/marshal'
        
        #{eval_code}
        
        nil
      }
    end
    
    def call(env)
      # Remove some values that can't be marshaled
      env.delete('rack.errors')
    
      # Call the adapter inside the sandbox,
      # the response will be marshaled and sent
      # back here in the jungle.
      @box.set :env, env
      @box.eval %{
        status, headers, body = app.call(env)
      
        # We ensure the response can be marshaled back to the
        # jungle by converting it to a simpler object.
        body_output = []
        body.each { |l| body_output << l }
      
        [status, headers, body_output]
      }
    end
  
    protected
      # Copy some constants and global variables inside the Sandbox
      def copy_globals
        %w(
          ::File::ALT_SEPARATOR
          ::File::SEPARATOR
          ::File::PATH_SEPARATOR
          $SAFE
        ).each { |v| @box.set v, eval(v) }
        # Copy loadpath
        $:.each { |i| @box.eval("$: << #{i.inspect}") }
      end

      # Copy the environment variables (+ENV+).
      def copy_env
        @box.set :ENV, {}
        ENV.each { |k,v| @box.eval("ENV[#{k.inspect}] = #{v.inspect}") }
      end 
  end
end
