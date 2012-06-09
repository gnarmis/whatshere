## Overview
What's Here is a collection of web services written using Sinatra. This project is structured like usual Ruby-based applications. You'll find all the web services in the `lib` directory. Also, you'll find the configuration of URLs in config.ru. This project is ready to deploy on Heroku's Cedar stack. Heroku maintains great documentation about deploying Rack-based apps on its Cedar stack, so I'd suggest you check those out.

The code is a little hacky in parts and this project went through many iterations without having many specs at all. The focus was always on exploration over methodical development. As such, treat this project as a WIP or a proof-of-concept. It is not production ready!

- Read through Sinatra's README at sinatrarb.com
- Read throug `lib` to acquaint yourself with all the webservices. The three main ones are `mobile_client`, `recommender`, and `tweetsnearme`.
- Acquaint yourself with Slim templates so that you can understand the views in mobile_client
- Understand the basics of Rack if you want to add other services

## Installation and Usage
- Install RVM and ruby-1.9.3, along with RubyGems
- Clone this repository
- Run `bundle install`. Later, add gems you need to Gemfile, run `bundle install`, and Bundler will install and package up your new gems too.
- Start building your project
- Modify your app routes in `config.ru`
- Add background processes and basically any process you need to run to start your app in devProcfile
- Procfile has been provided to allow you to easily deploy this on Heroku's Cedar stack. If you're only using Sinatra, it should be sufficient. Also, Sinatra-synchrony will speed your app up decently :)
- `rackup` to run your app

## API Key Setup (not needed if only using rec and tweetsnearme (like right now))
- Provide a yaml file with keys defined as simple mapping
- update services in lib/ with the appropriate KEYPATH value

You can add your own Rack-based frameworks in their own folders under `lib/`, putting your classes (which sub-class your favorite framework) under the main module (by default, it's called `Project`). Then, update `config.ru` and you're good to go!

## Development
- Run `rake` or `rake help` to see available tasks
- Insert `binding.pry` anywhere in your code to invoke the Pry REPL, which you can use for debugging purposes.
- There's simple logging and an example of a Capybara test you can look at in this template.
- protip: remove deleted files from Git (commit the deletions) by doing: `git ls-files --deleted | xargs git rm`
- protip: remember to run gem binaries (like Pry or Foreman) with `bundle exec` so that Bundler knows to take the path to your local gems in vendor/ruby