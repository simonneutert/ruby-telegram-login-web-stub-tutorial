# Telegram Login Ruby Roda Demo

**please, read the official telegram login article** \
at https://core.telegram.org/widgets/login _(at least skim it!)_

## For those who demo run this code 👋

Hey there, glad you gave this a spin! As this project tries to give other rubyists a hand to get tgram going, it is quite possible, that things might not be as straightforward, as I think they are. 

So, just in case the code isn't speaking for itself, or docs could be improved. Something's unclear, please, either open an issue or a PR with suggestions we can discuss. In both cases add as much details as possible (without leaking keys/credentials 🐞).

## Requirements

You definitely need:
* [ngrok](https://ngrok.com) (if there's a nicer substitute out there, one that would lower the effort for this project, please let me know 🙏)

For running this project locally you need one of the following two:
* Ruby >= 3.0
* Docker

People using Docker see their own paragraph below.

## What this does

This is a simple demo of the telegram login widget. \
You can login using your telegram account. \
Once logged in successfully, your profile is rendered. \
The data is stored in a session cookie (not persisted for a longer time). \
A background job is enqueued to greet via your telegram bot after a few seconds.

Optional:

Run `$ ruby bot.rb` to start the bot listening for messages. \
It will echo back the message you sent.

## Run this project

The project requires two parts. \
One being ngrok as gate to the internet, handing out a domain, telegram will use. \
The other is the code of this repo a.k.a the backend.

And of course you need to have your bot on telegram ready.

### ngrok Development Server

#### Telegram Bot Setup

* go, see [@BotFather](https://telegram.me/botfather) on telegram
* create/choose your desired bot (you should have a bot already)
* create your bot and set the domain in the settings
  * the domain you copied from ngrok (https://....ngrok.io)
* see what .env.example ships with and create a `.env` (copy of .env.example) edit with your credentials

#### Start and keep running an ngrok Development Server

have ngrok installed and start a server by `$ ngrok http -p 5555` and copy the https url you are given

**Remember** you need to set the domain in the bot settings, each time you restart ngrok!

### Run the backend

Run it local using (A) Ruby or via (B) Docker.

#### A - Ruby

* clone this repo
* `$ bundle install`
* open another terminal window and run `bundle exec rackup -p 5555`
* open your **browser at the given ngrok https://** (‼️) domain

clap your hands and login with telegram!

#### B - Docker

```shell
# builds the image
docker build . -t ruby-telegram-login`
# run the image with your envs replaced
docker run -it --rm -p5555:5555 \
  -e TELEGRAMBOTNAME='yourBot' \
  -e TELEGRAMBOTSECRETKEY='123:abc-def' \
  -e 'a-super-long-128-char-string' \
  ruby-telegram-login
```

* open your browser at the given **ngrok https://** domain

If you messed up a step above, simply build again, then run again, again, again

### Optional: run the "echoing" bot

```shell
$ ruby bot.rb
```
Read/Skim the code to see how it works. [bot.rb](bot.rb)
