RAILS_ROOT = "/home/ec2-user/selfiejobs/current"

def generic_god_config(god, options={})
  god.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running  = false
    end
  end

  god.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above    = options[:memory_max]
      c.interval = 20
      c.times    = [3, 5]
    end

    restart.condition(:cpu_usage) do |c|
      c.above    = options[:cpu_max]
      c.interval = 20
      c.times    = 5
    end
  end
end

God.watch do |god|
  god.group = "selfies"
  god.name  = "thin"
  god.dir   = RAILS_ROOT
  god.start = "bundle exec thin start -p 3000"
  god.log   = "./log/thin.log"
  god.keepalive

  god.behavior(:clean_pid_file)

  generic_god_config(god, :memory_max => 100.megabytes, :cpu_max => 50.percent)
end

God.watch do |god|
  god.group = "selfies"
  god.name  = "sidekiq"
  god.dir   = RAILS_ROOT
  god.start = "bundle exec sidekiq"
  god.log   = "./log/sidekiq.log"
  god.keepalive

  god.behavior(:clean_pid_file)

  generic_god_config(god, :memory_max => 100.megabytes, :cpu_max => 80.percent)
end
