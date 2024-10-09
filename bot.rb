# frozen_string_literal: true

require 'rubygems'

require 'bundler/setup'
Bundler.require(:default)

require 'telegram/bot'

BOT_KEY = ENV.delete('TELEGRAMBOTSECRETKEY')
BOT = Telegram::Bot::Client.new(BOT_KEY)

Signal.trap('INT') do
  BOT.stop
end

BOT.listen do |message|
  # it will be in an infinity loop until `bot.stop` command
  # (with a small delay for the current `fetch_updates` request)
  case message.text
  when '/start'
    BOT.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
  when '/stop'
    BOT.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
  else # echo
    BOT.api.send_message(chat_id: message.chat.id, text: message.text)
  end
end
