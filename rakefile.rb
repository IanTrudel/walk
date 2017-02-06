require("rake")
require("yaml")
require("drb/drb")
require("pp")

CONFIG = YAML.load_file("walkabout.yml")
DRbSERVER = "druby://#{CONFIG['walkabout']['server']}:#{CONFIG['walkabout']['port']}"

DRb.start_service

walkabout = DRbObject.new_with_uri(DRbSERVER)

walkabout.tasks.each { |task|
   walkabout[task].reenable
   desc walkabout[task].full_comment
   task(task) { puts walkabout[task].invoke }
}

__END__

# Ignore Test namespace
puts task.scope.path