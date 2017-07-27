# = path_finder.rb:: Basic Path Handling
#
# There are libraries that do this but most also
# seem to be too clever (i.e. Hashie).

# Parses the provided path into a sequence of `Stepper's which will be
# used to traverse each graph edge. Mostly analogous to `#dig' but with support
# for custom logic: presently spreading on `*'.

# Presently attribute names cannot contain a `.'. There's a hope that this can just
# be avoided and the parser remain as dumb as it is, but if it does need to be supported
# then square bracket syntax and/or quoting with a smarter parser should be introduced.
class PathFinder
  def initialize(path)
    @steps = Array.new
    path.to_s.split('.').map do |it|
      @steps.push(it == '*' ? SpreadStepper.new : Stepper.new(it))
    end
  end

  def walk(o)
    result = @steps.reduce(o) {|o, step| step.step(o) }
    # Adding an additional box would let polymorphism handle this, but that seems excessive
    result.is_a?(Spreader) ? result.o : result
  end
end

# Call dig with the contained path, convert integers to handle Arrays
class Stepper
  def initialize(leg)
    @leg = Integer(leg) rescue leg
  end

  def step(o)
    o.dig(@leg)
  end
end

# Used for the `*' token to provide a `Spreader'
class SpreadStepper
  def step(o)
    Spreader.new(o)
  end
end

# A wrapper around an `Array' to override the `#dig' method
# with one that `map's the call.
# Also used to retain the fact that this spreading is desired
# (rather than an array received as input)
class Spreader
  attr_reader :o

  def initialize(o)
    @o = o
  end

  def dig(path)
    Spreader.new(@o.map{|it| it.dig(path)})
  end
end