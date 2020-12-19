# BehindTheName

This is Ruby wrapper around the API provided from the BehindTheName.com website.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'behind_the_name'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install behind_the_name

## Usage

Refer to https://www.behindthename.com/api/help.php for the official documentation.

```ruby
BehindTheName.api_key = 'YOUR_API_KEY'
BehindTheName.lookup(name: 'George', exact: true)
BehindTheName.random(usage: 'Celtic Mythology')
BehindTheName.related(name: 'Brigit', gender: :feminine)
```

I've no idea what the error codes mean, beyond the description given in the response.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Running `bin/scrape_appendices` will update the yml files; it will require that you `gem install oga` as well.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/saraid/behind_the_name.

