# Assorted utility functions
# The deprecation piece should be extracted and the rest considered dead.
module BrineUtil
  # reevaluate passed block until it returns without throwing an exception
  # or `time` elapses; retry every `interval`
  def retry_for(time, interval=1)
    failure = nil
    quit = Time.now + time
    while (Time.now <= quit)
      begin
        return yield
      rescue Exception => ex
        failure = ex
        sleep interval
      end
    end
    raise failure
  end

  # iterate over data table and shave_value for each cell value
  # mutates and returns table
  # FIXME: Shouldn't be needed and removed after use of tables is dropped
  def transform_table!(table)
    table.cells_rows.each do |row|
      row.each{|cell| cell.value = Transform(cell.value)}
    end
    table
  end
end

def replaced_with(type, new_step, version, multiline=nil)
  deprecation_message(version, "Replace with: #{type} #{new_step}\n#{multiline}")
  step new_step, multiline
end

##
# Output a deprecation message with contents `msg`
#
# Nothing will be output if BRINE_QUIET_DEPRECATIONS is set.
#
# @param version [String] Version at which this feature will be removed.
# @param message [String] The message to log.
##
def deprecation_message(version, message)
  warn "DEPRECATION - Removal planned for #{version}: #{message}" unless ENV['BRINE_QUIET_DEPRECATIONS']
end
