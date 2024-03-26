# frozen_string_literal: true

require_relative '../version'

module Ocean
  module Commands
    class Version < Dry::CLI::Command
      desc 'Print version'

      def call
        puts VERSION
      end
    end
  end
end
