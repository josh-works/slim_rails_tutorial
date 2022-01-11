As part of some work I'm doing for Alex & Trevor at https://www.teamworkonline.com/, I needed a 'kick the tires' application.

Teamwork online uses the following tools which I'm aiming to integrate as it feels helpful in this tutorial, AKA a guide I'm writing for myself.


```ruby
gem "slim-rails" # https://github.com/amatsuda/kaminari
gem "bootstrap"
gem "bootstrap4-kaminari-views"
gem "kaminari", "~> 1.2.1"

```

Follow along here on Github (https://github.com/josh-works/slim_rails_tutorial/tree/main) or on Heroku: https://rails-slim-tutorial.herokuapp.com/.

I'm allocating not a lot of time to this, so lets get started.

---------------

```shell
rails _6.1.3_ new slim_rails_tutorial -d postgresql
cd slim_rails_tutorial

gc -m "initial commit"

hub create # initialize gh repo
heroku create # rails slim tutorial

gpo main # git push origin main
gph main # git push heroku main

# by now, error came back from heroku, telling me to run the following command:
 # bundle lock --add-platform x86_64-linux
 # so I did:
 
bundle lock --add-platform x86_64-linux

# git add, git push heroku, and it works, I can see a `rails new` page on 
# https://rails-slim-tutorial.herokuapp.com/, and the same when I run `rails s`
# locally, which I will now do:

rails s
```

OK, lets get some hello-world stuff going w/Slim. Over to: https://github.com/slim-template/slim-rails

Adding to Gemfile: `gem "slim-rails"`, `bundle install`.

That was easy. 

Let's generate a simple model of `quotes` that we'll fill with Lorem Ipsum, via faker, and off to the races.

In my `seeds.rb` I'm going to mock up some of the model that I hope to have, sorta a TDD:

```ruby
# seeds.rb

50.times do |n|
  Quote.new(Faker::Quote)
end
```

Then `root` to `QuotesController#Index`, something like:

```ruby
# routes.rb

root: 'QuotesController#index'
```

(have not used `rails generate scaffold` recently? me neither. I used `tldr rails generate` to remind myself.)

```
rails g scaffold Quote body:text author:text
```

and update `routes.rb` with:

```
# routes.rb
root to: "quotes#index"
```
Reload your home page, what do you see?

An error page! Run your migrations!

```
rails db:migrate
```

Reload again, get:

```
Webpacker::Manifest::MissingEntryError in Quotes#index
```
Restart rails server, still an error. Lets create one quote real quick in the rails console:

```ruby
Quote
```

Nope, not it. 

Found stack overflow question/answer:

```
run `rails webpacker:install`
```

didn't do it, I had the wrong `yarn` version, I think. Found [https://stackoverflow.com/questions/60491830/error-cannot-find-module-rails-webpacker-rails-6](https://stackoverflow.com/questions/60491830/error-cannot-find-module-rails-webpacker-rails-6), did:

```
yarn add @rails/webpacker
@npmcli/fs@1.1.0: The engine "node" is incompatible with this module. Expected version "^12.13.0 || ^14.15.0 || >=16". Got "14.0.0"

rm -rf node_modules
yarn install --check_files
yarn add @rails/webpacker
rails webpacker:install

```

OK, using the wrong version of node. 

I use `nvm`, but it's old, so lets do some upgrading:

```
brew upgrade nvm
```
this worked, but nvm wasn't available in my path. The recommended PATH stuff:

```
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion 
  # but I (Josh) don't use the bottom line because it slows my shell down last time I added it, IIRC.

```
```shell
nvm install 16

rm -rf node_modules
yarn install --check_files
yarn add @rails/webpacker # huzzah it worked!
rails webpacker:install # huzzah it worked
```


Restart the rails server and...

Voilà, we're good to go!

---------------

in the rails console session, now:

```ruby
Quote.create!(body: "May you live in interesting times", author: "unknown")
Quote.create!(body: "That which does not kill us makes us stronger.", author: "Friedrich Nietzsche")
```

Now you've got quotes. Lets deploy this to heroku, make sure it's working, and load some data from the rails console:

----------

swapping app to postgres for Heroku, in:

- https://github.com/josh-works/slim_rails_tutorial/commit/f912abe418ab7eeea26fe5ec1e2b6a3598cb8d7b
- https://github.com/josh-works/slim_rails_tutorial/commit/17fce26b18e8e1cd7f5657e297e0abc367311ecc


Update everything locally, then push to heroku:
```
rails db:migrate
git add/commit/push
heroku run rails db:migrate
```

and re-load the app. connect to the console, make new things. you're good to go.

Taking a few min break. Took longer than I'd hoped to just get _here_
------------------

Next, lets add faker so I can have 100 quotes, so I'll get some good pagination stuff. Then I'll drop in slim templating, pushing all to heroku all the while.

ok, adding/installing `slim-rails`.

Using https://gist.github.com/hmans/1aa5acac56c7ee995900fe65040adeb3:

```
doctype html
html
  head
    title My App
    meta name="viewport" content="width=device-width, initial-scale=1.0"
    = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
    = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'
    = csrf_meta_tags
    = csp_meta_tag

  body
    = yield
```

committing it all, reloading it, all is working it seems. I now am using `application.html.slim` instead of `application.html.erb`, and it just seems to magically be working. That was easy.

Lets add bootstrap, but first doing bootstrap and _then_ slim, rather than the other way around.

