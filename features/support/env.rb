require 'aruba/cucumber'

Before do
  write_file 'features/support/env.rb',
             <<-END
             require 'brine'
             require 'brine/test_steps'
             World(brine_mix)
             END
end
