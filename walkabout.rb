require("rake")
require("yaml")
require("drb/drb")
require("pp")

# Scheduler friendly: silently shutdown the service when an instance is already running
if $0 == __FILE__
  exit unless File.open("#{File.basename($0)}.lock", File::RDWR|File::CREAT, 0644).flock(File::LOCK_EX | File::LOCK_NB)
end

$stdout.sync = true
$stdin.sync = true

Rake.extend(DRbUndumped)

Rake::TaskManager.record_task_metadata = true

task :default do
  Rake::application.options.show_tasks = :tasks
  Rake::application.options.show_task_pattern = //
  Rake::application.display_tasks_and_comments
end

def capture
   str = StringIO.new
   stdout, stderr = $stdout, $stderr
   $stdout = $stderr = str
   yield
   str.string   
ensure
   $stdout, $stderr = stdout, stderr
   str.string
end

module Rake   
   class Task
      alias_method :old_invoke, :invoke
      
      def invoke(*args)
         capture { old_invoke(*args) }
      end
   end
end

# Configuration loaded from YAML needs to be untainted to work with $SAFE security feature
CONFIG = YAML.load_file("walkabout.yml")
DRbSERVER = "druby://#{CONFIG['walkabout']['server']}:#{CONFIG['walkabout']['port']}".untaint

Dir.glob("recipes/**/*.rake").sort.each { |recipe|
   puts "Loading #{File.basename(recipe)}" #if Rake.application.options.trace
   load recipe
}

$SAFE = 1  # Running sandbox, disable eval()

DRb.start_service(DRbSERVER, Rake.application)
DRb.thread.join