# Binding extensions loaded inside the sandbox

# Ok I confess, I have no idea what to do here.
# I get some weird NoMethodError include on <Binding:XXXXX>
class Binding
  def include(i)
    # FIXME wth?
  end
end