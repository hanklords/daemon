# -*- encoding: utf-8 -*-

require File.expand_path("../lib/daemon", __FILE__)

Gem::Specification.new do |s|
  s.summary = "Daemon module"
  s.name = "daemon"
  s.author = "Maël Clérambault"
  s.email =  "mael@clerambault.fr"
  s.files = %w(lib/daemon.rb LICENSE README.md)
  s.version = Daemon::VERSION
end
