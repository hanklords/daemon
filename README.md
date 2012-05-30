Daemon  
======

Daemon is a library to build unix daemons in ruby.

The source code is located at : <http://github.com/hanklords/daemon>

Usage
-----

### Manual setup

    require "daemon"

    class MyDaemon
      include Daemon

      def start
        daemon_pid_file = "mydaemon.pid" # Where to store the pidfile of the daemon. "/tmp/#{class name}" by default
        daemon_start

        # Do daemon stuff
      end

      def stop
        daemon_stop
      end
    end

    mydaemon = MyDaemon.new
    mydaemon.start

    mydaemon.daemon_pid # => pid of the daemon
    mydaemon.daemon_running? => true


### Use command line switches

    require "daemon"

    class MyDaemon
      include Daemon

      def start
        daemon_run!

        # Do daemon stuff
      end
    end

    mydaemon = MyDaemon.new
    mydaemon.start

Launch your code without arguments to see the available options
