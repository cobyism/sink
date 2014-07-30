Gem::Specification.new do |s|
  s.name        = 'sink'
  s.version     = '0.0.3'
  s.summary     = "Sink"
  s.description = "Auto-sink folders via GitHub."
  s.authors     = ["Coby Chapple"]
  s.email       = 'coby@github.com'
  s.files       = ["lib/sink.rb"]
  s.homepage    = 'http://github.com/cobyism/sink'
  s.license     = 'MIT'
  s.executables << 'sink'

  s.add_dependency "git",     "~> 1.2"
  s.add_dependency "octokit", "~> 3.0"
  s.add_dependency "dotenv",  "~> 0.11"
end
