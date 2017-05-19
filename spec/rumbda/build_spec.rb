require_relative '../../lib/rumbda'

RSpec.describe Rumbda::Build do
  describe '.check_for_files' do
    let(:target_dir) { 'test' }
    let(:main_rb) { File.join(target_dir, 'source', 'main.rb') }
    let(:gemfile) { File.join(target_dir, 'Gemfile') }
    let(:gemfile_lock) { File.join(target_dir, 'Gemfile.lock') }

    before :example do
      FileUtils.mkdir(target_dir)
      FileUtils.mkdir(File.join(target_dir, 'source'))
      FileUtils.touch(main_rb)
      FileUtils.touch(gemfile)
      FileUtils.touch(gemfile_lock)
    end

    after :example do
      FileUtils.rm_rf(target_dir)
    end

    it 'aborts if main.rb does not exist' do
      FileUtils.rm(main_rb)
      expect(Rumbda::Build).to receive(:abort)
      Rumbda::Build.check_for_files(target_dir)
    end

    it 'aborts if Gemfile does not exist' do
      FileUtils.rm(gemfile)
      expect(Rumbda::Build).to receive(:abort)
      Rumbda::Build.check_for_files(target_dir)
    end

    it 'aborts if Gemfile.lock does not exist' do
      FileUtils.rm(gemfile_lock)
      expect(Rumbda::Build).to receive(:abort)
      Rumbda::Build.check_for_files(target_dir)
    end

    it 'does not abort if main.rb exists' do
      expect(Rumbda::Build).to_not receive(:abort)
      Rumbda::Build.check_for_files(target_dir)
    end

    it 'does not abort if Gemfile exists' do
      expect(Rumbda::Build).to_not receive(:abort)
      Rumbda::Build.check_for_files(target_dir)
    end

    it 'does not abort if Gemfile.lock exists' do
      expect(Rumbda::Build).to_not receive(:abort)
      Rumbda::Build.check_for_files(target_dir)
    end
  end

  describe '.create_zip_file' do
    let(:source) { 'create_zip_file_source' }
    let(:source_files) { (0..5).map { |n| File.join(source, "source_#{n}") } }
    let(:destination) { 'test_index.zip' }

    before :example do
      FileUtils.mkdir(source)
      source_files.each { |source_file| FileUtils.touch(source_file) }
    end

    after :example do
      FileUtils.rm_rf(source)
      FileUtils.rm_rf(destination)
    end

    it 'creates a zip file from the source directory' do
      Rumbda::Build.create_zip_file(source, destination)
      expect(File.exist?(destination)).to be true
    end
  end
end
