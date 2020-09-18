# Telegram Login Ruby Roda Demo

**please, read the official telegram login article**  
at https://core.telegram.org/widgets/login _(at least skim it!)_

## Requirements

* Ruby >= 2.6
* Docker
* Ngrok

People using Docker see their own paragraph below.

## Ngrok Development Server

have ngrok installed and start a server by `$ ngrok http -p 5555` and copy the https url you are given

* see what .env.example ships with and create a `.env` (copy of .env.example) edit with your credentials
* go, see [@BotFather](https://telegram.me/botfather) on telegram
* send him the command `/setdomain`
* choose your desired bot (you should have a bot already)
* and set to the domain you copied from ngrok (https://....ngrok.io)

## Run the app

run it local using Ruby or with Docker

### Get going with local Ruby

* clone this repo
* `$ bundle install`.  
* open another terminal window and run `rackup -p 5555`
* open your browser at the given ngrok https:// domain

clap your hands and login with telegram!  
B-)

### Docker

* `$ docker build . -t ruby-telegram-login`
* `$ docker run -it --rm -p5555:5555 ruby-telegram-login`
* open your browser at the given ngrok https:// domain

if you messed up a step above, simply build again, then run again, again, again
