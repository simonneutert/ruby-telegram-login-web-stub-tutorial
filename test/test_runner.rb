# frozen_string_literal: true

# bundler setup
require 'bundler/setup'
Bundler.require # (:default)

# spec/test requires
require 'test/unit'
require 'timecop'
# app requires
require 'dotenv/load'
require 'digest'
require 'openssl'

# require business logic
Dir.glob('lib/*.rb').each { |file| require_relative "../#{file}" }

# require test files, results in running all tests
Dir.glob('test/*_test.rb').each { |file| require_relative "../#{file}" }
