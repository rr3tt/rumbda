module Rumbda
  GEMFILE_CONTENTS = <<-HEREDOC
source 'https://rubygems.org'

# add runtime dependencies here, they will be included in the index.zip

# This is the aws ruby sdk provides a ruby client for interacting with AWS apis.
# gem 'aws-sdk'

# DO NOT REMOVE; bundler version MUST match the version that the traveling ruby uses, which is currently 1.9.9.
gem 'bundler', '= 1.9.9'

# gems in the development group will not be included in the index.zip
group :development do
  gem 'rumbda'
end
HEREDOC
  RUBY_VERSION_FILE_CONTENTS = '2.2.2'.freeze
  GITIGNORE_FILE_CONTENTS = "tmp_rumbda\nindex.zip".freeze

  class Init
    def self.run(directory)
      source_dir = File.join(directory, 'source')
      FileUtils.mkdir(source_dir)
      puts "Created: #{source_dir}"

      main_rb = File.join(source_dir, 'main.rb')
      FileUtils.touch(main_rb)
      puts "Created: #{main_rb}"

      ruby_version_file = File.join(directory, '.ruby-version')
      FileUtils.touch(ruby_version_file)
      File.open(ruby_version_file, 'a') { |f| f.puts RUBY_VERSION_FILE_CONTENTS }
      puts "Created: #{ruby_version_file}"

      gitignore_file = File.join(directory, '.gitignore')
      FileUtils.touch(gitignore_file)
      File.open(gitignore_file, 'a') { |f| f.puts GITIGNORE_FILE_CONTENTS }
      puts "Created: #{gitignore_file}"

      gemfile = File.join(directory, 'Gemfile')
      FileUtils.touch(gemfile)
      File.open(gemfile, 'a') do |f|
        f.puts GEMFILE_CONTENTS
      end
    end
  end
end
