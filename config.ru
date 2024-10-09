# frozen_string_literal: true

require 'rubygems'

require 'bundler/setup'
require 'sucker_punch' # require this before the rest of the gems
Bundler.require(:default)

require 'dotenv/load'
require 'digest'
require 'openssl'
require 'telegram/bot'

Dir.glob('./lib/**/*.rb').sort.each { |file| require file }

require_relative 'app'
run App
