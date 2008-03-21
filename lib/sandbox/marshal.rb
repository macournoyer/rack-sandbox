# Sandbox marshals object before sending them back in the Jungle.
# Since we return the response we need to marshal some objects
# that do not support marshaling out of the box.
# This is loaded inside the Sandbox and in the Jungle (outside).

require 'stringio'
class StringIO
  def marshal_dump
    @string
  end
  
  def marshal_load(string)
    @string = string
  end
end
