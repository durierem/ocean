# frozen_string_literal: true

require 'fileutils'

module Ocean
  module Commands
    class Init < Dry::CLI::Command
      desc 'Initialize ocean by setting up appropriate $PATH'

      def initialize
        super
        @shims_path = File.join(Dir.home, '.ocean', 'shims')
        @shim = File.join(@shims_path, 'oceanshim')
      end

      def call(*)
        # TODO: detect user's shell and prepend to PATH
        return if File.exist?(@shim)

        FileUtils.mkdir_p(@shims_path)
        File.open(@shim, 'w') do |file|
          file.write(code)
          file.chmod(0o755)
        end

        # command = "/usr/bin/fish -c \"fish_add_path --prepend --path --move #{@shims_path}\""
        # system command, exception: true
      end

      private

      def code
        <<~RUBY
          #!/usr/bin/env ruby

          require 'yaml'

          def find_executable_in_path(executable, path)
            paths = path.split(File::PATH_SEPARATOR)
            paths.each do |path|
              exe_path = File.join(path, executable)
              return exe_path if File.executable?(exe_path)
            end
            nil
          end

          program = File.basename(__FILE__)
          args = ARGV.join(' ')
          compose = File.join(Dir.pwd, 'docker-compose.yml')



          if File.exist?(compose) && YAML.parse_file(compose).to_ruby.dig('services', program)
            exec "docker compose -f \#{compose} run --rm --service-ports \#{program} \#{args}"
          else
            path_without_ocean = ENV['PATH']
                                .split(File::PATH_SEPARATOR)
                                .filter { |path| !path.include?('obin') }
                                .join(File::PATH_SEPARATOR)
            bin = find_executable_in_path(program, path_without_ocean)

            exec "\#{bin} \#{args}"
          end
        RUBY
      end
    end
  end
end
