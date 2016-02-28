# CarsApi [![Build Status](https://travis-ci.org/waterlink/cars_api.svg?branch=master)](https://travis-ci.org/waterlink/cars_api)

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

### Using with JRuby

To run development JVM server, use `bin/jruby-dev-server`. When running any
ruby command (like tests):

- `source .env.dev`
- don't use `bundle exec`
- just run command and see its output as the STDOUT/ERR output of
  `bin/jruby-dev-server`

For example to run tests:

```bash
$ source .env.dev
$ rake
# => Output goes to different terminal (optimally, `tmux` window)
```

## UseCase: Get N closest cars to the current location

![Get N closest cars to the current location](http://g.gravizo.com/source?https://raw.githubusercontent.com/waterlink/cars_api/master/docs/GetClosestCars.dot)

## UseCase: Initial import of cars data from the source

![Initial import of cars data from the source](http://g.gravizo.com/source?https://raw.githubusercontent.com/waterlink/cars_api/master/docs/InitialImport.dot)

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/waterlink/cars_api. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
