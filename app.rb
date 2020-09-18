require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'dotenv/load'

class App < Roda

  plugin :render
  plugin :head

  # set env to provide the Telegram Bot's secret key
  #
  # @return [Boolean]
  #
  def validate_auth(data_check_string) 
    bot_key = ENV['TELEGRAMBOTSECRETKEY']
    if bot_key
      digest = OpenSSL::Digest.new('sha256')
      secret_key = SHA256(bot_key)
      OpenSSL::HMAC.hexdigest(digest, bot_key, data_check_string) == bot_key
    else
      true
    end
  end

  route do |r|

    r.root do
      view("welcome")
    end

    r.on("login") do

      r.is do
        r.get do
          @telegram_login_bot_name = ENV['TELEGRAMBOTNAME']
          view("login")
        end

        r.post do
          params = JSON.parse(r.body.read)
          # README for NEWBIES ;-)
          #
          # inspect the params if you like!
          # type: `params`
          #
          # exit pry by sending `ctrl + d`
          #
          binding.pry 
          #
          # do_something(params)
          r.redirect('/')
        end
      end

    end
  end

end
