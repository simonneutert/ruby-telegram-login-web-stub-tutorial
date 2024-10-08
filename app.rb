# frozen_string_literal: true

require 'rubygems'

require 'bundler/setup'
Bundler.require(:default)

require 'dotenv/load'
require 'digest'
require 'openssl'

require_relative 'lib/auth_validator'

BOT_KEY = ENV.delete('TELEGRAMBOTSECRETKEY')

class AuthTooOldError < StandardError; end
class NoSecretKeyError < StandardError; end

class App < Roda
  plugin :render
  plugin :head
  plugin :sessions, secret: ENV.fetch('SESSION_SECRET', SecureRandom.hex(64))

  route do |r|
    r.root do
      view('welcome')
    end

    r.on 'auth' do
      r.redirect '/login' unless session['tgram']

      r.on 'profile' do
        @profile = session['tgram']
        view('profile')
      end
    end

    r.on('login') do
      r.is do
        r.get do
          @telegram_login_bot_name = ENV['TELEGRAMBOTNAME']
          view('login')
        end

        r.post do
          params = JSON.parse(r.body.read)
          cloned_params = Marshal.load(Marshal.dump(params))
          auth_status = AuthValidator.new.valid_auth?(cloned_params, BOT_KEY)
          session[:tgram] = cloned_params
          # README for NEWBIES ;-)
          #
          # inspect the params if you like!
          # type: `params`
          #
          # exit pry by sending `ctrl + d`
          #
          p "Auth Status: #{auth_status}"
          #
          # do_something(params)
          redirect_to = auth_status ? '/auth/profile' : '/login'
          { status: auth_status, redirect_to: }.to_json
        end
      end
    end
  end
end
