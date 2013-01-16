# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "easy-redis/version"

Gem::Specification.new do |s|
  s.name        = "easy-redis"
  s.version     = EasyRedis::VERSION
  s.authors     = ["Tyson Tate"]
  s.email       = ["tyson@stovepipestudios.com"]
  s.homepage    = "http://github.com/stvp/easy-redis-rb"
  s.summary     = "simple redis init"
  s.description = "simple redis init for rails projects"

  s.rubyforge_project = "easy-redis"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "redis", "~> 3.0"
  s.add_dependency "hiredis", "~> 0.4"
  s.add_development_dependency "rake"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-test"
end
