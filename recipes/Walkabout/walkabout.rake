require("rake")
require("drb/drb")
require("pp")

namespace(:walkabout) do
   desc("One line task description")
   task(:task_of_the_year) do |task|
      puts "Running #{task.name}"
   end

   desc("Generate an error")
   task(:error_horror) do |task|
      puts "Running #{task.name}"
      $stderr.puts "This is an error"
   end

   desc("Raise to the occasion")
   task(:raise_hell) do |task|
      puts "Running #{task.name}"
      raise "An occasion to be taken"
   end
   
   desc("Running a shell command (whoami)")
   task(:cmd) do |task|
      puts "Running #{task.name}"
      puts "Who am i? #{%x[whoami 2>&1]}"
   end
   
   desc("Shutdown Walkabout server")
   task(:shutdown) do |task|
      puts "Running #{task.name}"
      DRb.stop_service
   end
end

desc("Walkabout run 'em all")
task :walkabout => ["walkabout:error_horror", "walkabout:task_of_the_year", "walkabout:cmd"]