require 'thor'
require 'highline/import'
require 'open-uri'
require 'bundler'
require 'fileutils'
require 'bundler/setup'
Dir[File.join(__dir__, 'rumbda', '**', '*.rb')].each { |file| require file }
