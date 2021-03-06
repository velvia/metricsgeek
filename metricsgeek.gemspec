Gem::Specification.new do |s|
  s.name        = 'metricsgeek'
  s.version     = '0.0.6'
  s.date        = '2013-04-03'
  s.summary     = "Easily grok and analyze application metrics from a cluster."
  s.description = <<-EOT
Easily grok and analyze your application metrics from a cluster, in real time, with this command line tool /
gem. Compatible with HTTP JSON metrics routes as exposed by Coda Hale's metrics package, Jolokia, ruby-
metrics, or any metrics package that exposes metrics via an HTTP route as JSON.
EOT
  s.authors     = ["Evan Chan"]
  s.email       = 'velvia@gmail.com'
  s.files       = Dir['lib/**/*.rb', 'bin/*', '*.md']
  s.executables << "metricsgeek"
  s.homepage    =
    'http://github.com/velvia/metricsgeek'
end