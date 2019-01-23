# Assorted utility functions
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
  warn """
DEPRECATION: This step will be removed in version #{version}. Replace with:
#{type} #{new_step}\n#{multiline}""" unless ENV['BRINE_QUIET_DEPRECATIONS']
  step new_step, multiline
end
