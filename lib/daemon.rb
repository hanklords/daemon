require 'optparse'

module Daemon
  VERSION="0.3"
  attr_writer :daemon_disable
  
  def daemon_start
    return if @daemon_disable || daemon_running?
    daemon_init
    open(@daemon_pid_file, "w") {|f| f.write("")}
    Process.daemon
    @daemon_pid = $$
    open(@daemon_pid_file, "w") {|f| f.write(@daemon_pid)}
    $0 = @daemon_name
    at_exit {daemon_stop}
    self
  end
  
  def daemon_stop
    daemon_init
    Process.kill "TERM", daemon_pid
    File.delete(@daemon_pid_file) if @daemon_pid_file != "/dev/null"
    @daemon_pid = nil
  rescue StandardError, SystemCallError
  ensure
    self
  end
  
  attr_writer :daemon_pid
  def daemon_pid
    daemon_init
    @daemon_pid ||= open(@daemon_pid_file).read.to_i
  rescue StandardError, SystemCallError
    nil
  end
  
  def daemon_running?; !daemon_pid.nil? end
  
  attr_writer :daemon_name
  attr_reader :daemon_pid_file
  def daemon_pid_file=(pid_file)
    @daemon_pid_file = File.expand_path(pid_file) || "/dev/null"
  end
  
  def daemon_run!(argv = ARGV)
    daemon_init
    opts = OptionParser.new
    opts.banner += " (start | stop | restart | status)"
    opts.on("-f", "Run in foreground") { @daemon_disable = true }
    opts.on("-d", "Run in background, default") { @daemon_disable = false }
    opts.on("-p pid", "Path to the pid file, default : '#@daemon_pid_file'")  { |pid|
       self.daemon_pid_file = pid
    }
    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end

    opts.parse!(argv)
    case argv[0]
    when "start"
      if daemon_running?
        puts "Already started"
        exit
      end
      
      puts "Started"
      daemon_start
    when "stop"
      daemon_stop
      puts "Stopped"
      exit
    when "restart"
      daemon_stop
      daemon_start
    when "status"
      puts daemon_running? ? "Running" : "Stopped"
      exit
    when "", nil
      puts opts
      exit
    else
      puts "Unrecognized command : '#{argv[0]}'."
      puts opts
      exit
    end
  end
  
  private
  def daemon_init
    @daemon_name ||= self.class.name[/\w+$/].downcase
    @daemon_pid_file ||= "/tmp/#{daemon_name}.pid"
  end
end
