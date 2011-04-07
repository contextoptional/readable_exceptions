# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "readable_exceptions/version"

Gem::Specification.new do |s|
  s.name        = "readable_exceptions"
  s.version     = ReadableExceptions::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chad Krsek"]
  s.email       = ["chad@contextoptional.com"]
  s.homepage    = ""
  s.summary     = %q{Easily configure human readable error messages for your exception classes, or for classses declared in libraries you use.}
  s.description = %q{Easily configure human readable error messages for your exception classes, or for classses declared in libraries you use.}

  s.rubyforge_project = "readable_exceptions"

  s.add_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
