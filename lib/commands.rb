# frozen_string_literal: true

require_relative 'commands/version'
require_relative 'commands/init'
require_relative 'commands/up'
require_relative 'commands/down'

module Ocean
  module Commands
    extend Dry::CLI::Registry

    register 'version', Version, aliases: ['-v', '--version']
    register 'init', Init
    register 'up', Up
    register 'down', Down
  end
end
