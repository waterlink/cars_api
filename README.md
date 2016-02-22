# CarsApi

Car sharing API, that shows best car sharing options around the user's
location.

## Setting up

First clone this repository:

```bash
$ git clone https://github.com/waterlink/cars_api
$ cd cars_api
```

Then run setup script:

```bash
$ ./bin/setup
```

## Usage

### Run API server

```bash
$ bundle exec ./exe/cars_api server

# or if you have proper ruby setup, the `cars_api` executable should be
# available on `PATH` after running a `./bin/setup` script:
$ bundle exec cars_api server
```

### Import cars locations from `JSON` formatted file

```
$ bundle exec cars_api import /path/to/data.json
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can
also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To run the test suite, run `bundle exec rake`.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/waterlink/cars_api. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
