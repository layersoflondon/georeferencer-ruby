# Georeferencer - a Ruby client for [Georeferencer](http://www.georeferencer.com)
This is a Ruby library which allows you to get data from Georeferencer about images you've submitted to be georeferenced, along with progress data and contributors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'georeferencer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install georeferencer

## Configuration

You need at least the subdomain of your Georeferencer account. Here's a full list of all the configurable options with their defaults:

```
Georeferencer.configure do |config|
  config.proxy = nil
  # Configure your proxy address here - e.g.
  # config.proxy = "https://localhost:9998"
  
  config.ssl_options = nil
  # options passed to ssl_options will be passed on to Faraday - e.g.
  # config.ssl_options = {
  #   verify: false
  # }
  config.subdomain = 'yoursubdomain'
  config.perform_caching = false
  config.cache = ActiveSupport::Cache.lookup_store(:memory_store)
  config.logger = Logger.new(STDOUT)
  config.user_agent = "Georeferencer Ruby Client #{Georeferencer::VERSION} (https://github.com/layersoflondon/georeferencer-ruby)"
end

```
   
A minimal example would be :

```
   Georeferencer.configure do |config|
       config.subdomain = 'yoursubdomain'
   end
```

If you're using this gem in Rails, the logger and caching settings will follow those you've set in your Rails configuration.

## Usage

### Images
Get a list of images:

```
Georeferencer::Image.all

```

There is a scope defined for unreferenced images:

```
   Georeferencer::Image.unreferenced
```

And you can pass in a collection name:

```
    Georeferencer::Image.where(collection: 'my-collection')
```

There is no endpoint to get a list of collections but Klokan can provide them.

## Contributors

Contributors work in the same way, although there is no 'detail' page for contributors.

```
Georeferencer::Contributor.all

```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/layersoflondon/georeferencer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
