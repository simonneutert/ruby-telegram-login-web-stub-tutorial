# frozen_string_literal: true

BOT_KEY = ENV.delete('TELEGRAMBOTSECRETKEY')
BOT = Telegram::Bot::Client.new(BOT_KEY)

class App < Roda # rubocop:disable Style/Documentation
  plugin :render
  plugin :head
  plugin :sessions, key: 'tgram-login',
                    secret: ENV.fetch('SESSION_SECRET', SecureRandom.hex(64)),
                    max_seconds: 86_400 * 7 # 1 week

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

    r.post 'logout' do
      session.clear
      r.redirect '/'
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

          if auth_status
            session['tgram'] = cloned_params
            puts "@#{session['tgram']['username']}'s auth status: #{auth_status}"
            Jobs::BotJob.perform_async(session['tgram'])
          end

          # do_something_more_with_the_user(params)

          # redirect to the profile page if the user is authenticated via js script in the frontend
          redirect_to = auth_status ? '/auth/profile' : '/login'
          { status: auth_status, redirect_to: }.to_json
        end
      end
    end
  end
end
