# frozen_string_literal: true

module Ocean
  module Commands
    class Up < Dry::CLI::Command
      desc 'Set up shims for the current compose'
      argument :services, type: :array, required: true, desc: 'The compose services to shim'

      def initialize
        super
        @shims_path = File.join(Dir.home, '.ocean', 'shims')
        @canon = File.join(@shims_path, 'oceanshim')
      end

      def call(services: [], **)
        services.each do |service|
          shim = File.join(@shims_path, service)
          next if File.exist?(shim)
          FileUtils.ln_s(@canon, shim)
        end
      end
    end
  end
end
