# type_checks.rb -- checks whether provided is a valid instance of a specified type
#
# Provides validation for standard JSON type

require 'rspec/expectations'

# This will be made extensible so it can replace current domain specific check logic
class TypeChecks
  include RSpec::Matchers

  def initialize
    @map = {
      Object: be_a_kind_of(Hash),
      String: be_a_kind_of(String),
      Number: be_a_kind_of(Numeric),
      Integer: be_a_kind_of(Integer),
      Array: be_a_kind_of(Array),
      DateTime: be_a_kind_of(Time),
      Boolean: satisfy{|it| it == true || it == false }
    }
  end

  def for_type(type)
    @map[type.to_sym] || raise("Unsupported type #{type}")
  end
end

module TypeChecking
  def type_checks
    @type_check ||= TypeChecks.new
  end

  def type_check_for(type)
    type_checks.for_type(type)
  end
end
