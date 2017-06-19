## coercer.rb::

class Coercer
  def initialize
    @map = Hash.new(->(l, r){[l, r]})
    @map[[String, DateTime]] = ->(l, r){[DateTime.parse(l), r]}
  end

  def coerce(l, r)
    @map[[l.class, r.class]].call(l, r)
  end
end

module Coercion
  def coercer
    @coercer ||= Coercer.new
  end
end
