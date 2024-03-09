# Tlopo::Logger

A simple library to initialize and configure a logger

## Installation
A simple `gem install tlopo-logger` will do

## Usage

There are 3 main features: 
1. Configurable logging level through environment variable: `LOG_LEVEL=<debug|info|error|fatal|unknown>`
2. Logging in JSON format, configurable through environment variable: `LOG_JSON=true`
3. Capable of omitting sensitive values

Simple Usage: 
```ruby
require 'tlopo/logger'
LOGGER.info 'Hello World'
```
Omitting Sensitive Values: 
```ruby
require 'tlopo/logger'
pass='abc123'
LOGGER.add_sensitive 'secret', pass
LOGGER.info "My password is #{pass}"
# I, [2024-03-08T21:02:00.179194 #39840]  INFO -- : My password is [REDACTED:secret]
```

## Tips

### Change log device
The logger is configured to log to stderr by default, but we can easily change this behavior
```ruby
require 'tlopo/logger'

# we can use a file descriptor
LOGGER.reopen $stdout

# or a file path
LOGGER.reopen '/tmp/log'

LOGGER.info 'Hello World!'
```

### Add progname
The progname by default is nil, but perhaps you want to set it when logging from an instance of a class
```ruby
require 'tlopo/logger'

class Foo
  def initialize
    @logger = LOGGER.class.new $stderr, progname: self.class
  end

  def greetings
    @logger.info 'Hello World!'     
  end
end

Foo.new.greetings
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tlopo-ruby/tlopo-logger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tlopo-ruby/tlopo-logger/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tlopo::Logger project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tlopo-ruby/tlopo-logger/blob/main/CODE_OF_CONDUCT.md).
