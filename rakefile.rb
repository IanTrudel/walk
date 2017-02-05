require("rake")
require("drb/drb")
require("pp")

DRb.start_service

walkabout = DRbObject.new_with_uri("druby://localhost:8787")

walkabout.tasks.each { |task|
   walkabout[task].reenable
   desc walkabout[task].full_comment
   task(task) { puts walkabout[task].invoke }
}

__END__

# Ignore Test namespace
puts task.scope.path