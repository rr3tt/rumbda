module Rumbda
  class Build
    TRAVELING_RUBY_VERSION = '20150715-2.2.2'.freeze
    LINUX_VERSION = 'linux-x86_64'.freeze
    TEMP_DIRECTORY_NAME = 'tmp_rumbda'.freeze

    # TODO: fix using . or .. for dir_to_build
    def self.run(dir_to_build, options)
      check_for_files(dir_to_build)

      temp_dir = File.join(FileUtils.pwd, TEMP_DIRECTORY_NAME)
      dest_source_code_dir = File.join(temp_dir, 'source')

      vendor_dir = File.join(temp_dir, 'vendor')

      FileUtils.mkdir_p(dest_source_code_dir)
      FileUtils.mkdir_p(vendor_dir)
      FileUtils.cp_r(Dir.glob(File.join(dir_to_build, '*')) - [temp_dir], dest_source_code_dir)
      FileUtils.mv(File.join(dest_source_code_dir, 'Gemfile'), vendor_dir)
      FileUtils.mv(File.join(dest_source_code_dir, 'Gemfile.lock'), vendor_dir)

      Dir.chdir(TEMP_DIRECTORY_NAME) do
        bundle_install(vendor_dir)

        if Dir.exist?('ruby')
          puts "Found traveling ruby in #{TEMP_DIRECTORY_NAME}, skipping download."
        else
          download_traveling_ruby(TRAVELING_RUBY_VERSION, LINUX_VERSION)
          unpack_traveling_ruby(TRAVELING_RUBY_VERSION, LINUX_VERSION, 'ruby')
        end

        copy_bundler_config(
          File.expand_path(File.join('..', '..', '..', 'lambda', 'bundler-config'), __FILE__),
          File.join(vendor_dir, '.bundle')
        )

        copy_wrapper_script(
          File.expand_path(File.join('..', '..', '..', 'lambda', 'ruby_wrapper.sh'), __FILE__),
          'ruby_wrapper'
        )

        FileUtils.cp(
          File.expand_path(File.join('..', '..', '..', 'lambda', 'index.js'), __FILE__),
          'index.js'
        )
      end

      create_zip_file(TEMP_DIRECTORY_NAME, 'index.zip')

      FileUtils.rm_rf(TEMP_DIRECTORY_NAME) if options['cleanup']
    end

    def self.create_zip_file(source, destination)
      puts 'Creating zip file.'
      Dir.chdir(source) do
        success = system("zip -rq #{File.join('..', destination)} *")
        abort('Creating zip failed, exiting.') unless success
      end
    end

    def self.copy_bundler_config(source, destination)
      puts 'Copying bundler config.'
      FileUtils.mkdir_p(destination)
      FileUtils.cp(source, destination)
    end

    def self.copy_wrapper_script(source, destination)
      puts 'Copying wrapper script.'
      FileUtils.cp(source, destination)
      FileUtils.chmod(0755, destination)
    end

    def self.bundle_install(dir_with_gemfile)
      puts 'Installing bundle.'
      Bundler.with_clean_env do
        success = system(
          "cd #{dir_with_gemfile} && " \
          'env BUNDLE_IGNORE_CONFIG=1 bundle install --path . --without development'
        )

        abort('Bundle install failed, exiting.') unless success
      end

      puts 'Bundle install success.'
    end

    def self.download_traveling_ruby(version, target)
      puts "Downloading traveling ruby from #{traveling_ruby_url(version, target)}."

      File.open(traveling_ruby_tar_file(version, target), 'wb') do |saved_file|
        # the following "open" is provided by open-uri
        open(traveling_ruby_url(version, target), 'rb') do |read_file|
          saved_file.write(read_file.read)
        end
      end

      puts 'Download complete.'
    end

    def self.unpack_traveling_ruby(version, target, destination)
      puts 'Unpacking traveling ruby.'

      FileUtils.mkdir_p(destination)

      success = system("tar -xzf #{traveling_ruby_tar_file(version, target)} -C #{destination}")
      abort('Unpacking traveling ruby failed') unless success
      puts 'Unpacking traveling ruby successful.'

      puts 'Removing tar.'
      FileUtils.rm_rf(traveling_ruby_tar_file(version, target))
    end

    def self.traveling_ruby_url(version, target)
      "https://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-#{version}-#{target}.tar.gz"
    end

    def self.traveling_ruby_tar_file(version, target)
      "traveling-ruby-#{version}-#{target}.tar.gz"
    end

    def self.check_for_files(dir_to_build)
      unless File.exist?(File.join(dir_to_build, 'main.rb'))
        abort("Must have a file named 'main.rb' in #{dir_to_build}")
      end

      unless File.exist?(File.join(dir_to_build, 'Gemfile'))
        abort("Must have a file named 'Gemfile' in #{dir_to_build}")
      end

      unless File.exist?(File.join(dir_to_build, 'Gemfile.lock'))
        abort("Must have a file named 'Gemfile.lock' in #{dir_to_build}")
      end
    end
  end
end
