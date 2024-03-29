# frozen_string_literal: true

module Ocean
  module Commands
    class Down < Dry::CLI::Command
      desc 'Remove shims for the current compose'
      argument :services, type: :array, required: true, desc: 'The compose services to unshim'

      def initialize
        super
        @shims_path = File.join(Dir.home, '.ocean', 'shims')
        @canon = File.join(@shims_path, 'oceanshim')
      end

      def call(services: [], **)
        services.each do |service|
          shim = File.join(@shims_path, service)
          next unless File.exist?(shim)
          FileUtils.rm(shim)
        end
      end
    end
  end
end
