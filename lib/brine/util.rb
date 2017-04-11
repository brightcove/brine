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
  def transform_table!(table)
    table.cells_rows.each do |row|
      row.each{|cell| cell.value = Transform(cell.value)}
    end
    table
  end

end
