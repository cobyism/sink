Gem::Specification.new do |s|
  s.name        = 'sink'
  s.version     = '0.0.2'
  s.summary     = "Sink"
  s.description = "Auto-sink folders via GitHub."
  s.authors     = ["Coby Chapple"]
  s.email       = 'coby@github.com'
  s.files       = ["lib/sink.rb"]
  s.homepage    = 'http://rubygems.org/cobyism/sink'
  s.license     = 'MIT'
  s.executables << 'sink'

  s.add_dependency 'git'
  s.add_dependency "octokit", "~> 3.0"
end
