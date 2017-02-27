require_relative '../../lib/rumbda'

RSpec.describe Rumbda::Build do
  describe '.check_for_files' do
    let(:target_dir) { 'test' }
    let(:main_rb) { File.join(target_dir, 'main.rb') }
    let(:gemfile) { File.join(target_dir, 'Gemfile') }
    let(:gemfile_lock) { File.join(target_dir, 'Gemfile.lock') }

    before :example do
      FileUtils.mkdir(target_dir)
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
end
