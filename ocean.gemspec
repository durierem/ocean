# frozen_string_literal: true

require_relative 'lib/version'

Gem::Specification.new do |s|
  s.name        = 'ocean-cli'
  s.version     = Ocean::VERSION
  s.summary     = 'Expose compose services to the shell'
  s.description = ''
  s.author      = 'Rémi Durieu'
  s.homepage    = 'https://github.com/durierem/ocean'
  s.license     = 'MIT'
  s.email       = 'mail@remidurieu.dev'
  s.files       = [
    'bin/ocean',
    Dir.glob('lib/**/*'),
    'LICENSE',
    'README.md'
  ].flatten
  s.executables << 'ocean'

  s.required_ruby_version = '>= 3.1'

  s.add_runtime_dependency 'dry-cli', '~> 1.0'
  s.metadata['rubygems_mfa_required'] = 'true'
end
