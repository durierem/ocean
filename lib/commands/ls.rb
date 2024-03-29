# frozen_string_literal: true

module Ocean
  module Commands
    class Ls < Dry::CLI::Command
      desc 'List shimmed services'

      def initialize
        super
        @shims_path = File.join(Dir.home, '.ocean', 'shims')
      end

      def call(*)
        puts Dir.children(@shims_path).filter { |path| path != 'oceanshim' }
      end
    end
  end
end
