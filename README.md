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

Full list of commands and global options:

```bash
$ bundle exec ./exe/cars_api help
Commands:
  cars_api help [COMMAND]  # Describe available commands or one specific command
  cars_api import FILE     # Import car locations from JSON file
  cars_api server          # Start API server

Options:
  [--car-store=CAR_STORE]                    # CarStore adapter to use
                                             # Default: file-based
                                             # Possible values: in-memory, file-based, crate-io
  [--file-based-path=FILE_BASED_PATH]        # File based CarStore file path
                                             # Default: ./car_store.json
  [--crate-io-car-table=CRATE_IO_CAR_TABLE]  # Table name to store cars in
                                             # Default: cars_api_development_cars
  [--crate-io-servers=one two three]         # Servers to connect to for crate.io backed CarStore
                                             # Default: ["localhost:4200"]
```

### Run API server

```bash
$ bundle exec ./exe/cars_api server

# or if you have proper ruby setup, the `cars_api` executable should be
# available on `PATH` after running a `./bin/setup` script:
$ bundle exec cars_api server
```

By default server runs in file-based mode. By providing `--car-store=CAR_STORE`
CLI option one can change that. In particular, there is support for `crate.io`
database:

```bash
# assumes you have docker installed
# alternatively one could run: $ docker-compose up
$ bin/docker-launch-crate-io
...

# and run the server, that will use this crate.io instance
$ bundle exec cars_api server \
  --car-store=crate-io \
  --crate-io-servers="localhost:4200"   # by the way this is a default value
```

Full list of options can be found via `help server` command:

```bash
$ bundle exec cars_api help server
Usage:
  cars_api server

Options:
  [--server=SERVER]                          # Server to use
                                             # Default: thin
  [--server-require=SERVER_REQUIRE]          # Custom require to load server library (default=(--server value))
  [--server-port=N]                          # Custom port to run server on
                                             # Default: 4567
  [--server-bind=SERVER_BIND]                # Custom ip address to bind server to
                                             # Default: localhost
  [--car-store=CAR_STORE]                    # CarStore adapter to use
                                             # Default: file-based
                                             # Possible values: in-memory, file-based, crate-io
  [--file-based-path=FILE_BASED_PATH]        # File based CarStore file path
                                             # Default: ./car_store.json
  [--crate-io-car-table=CRATE_IO_CAR_TABLE]  # Table name to store cars in
                                             # Default: cars_api_development_cars
  [--crate-io-servers=one two three]         # Servers to connect to for crate.io backed CarStore
                                             # Default: ["localhost:4200"]

Start API server
```

### Import cars locations from `JSON` formatted file

```bash
$ bundle exec cars_api import /path/to/data.json
```

This command needs to use same `CarStore` configuration that `server` uses, for example:

```bash
$ bundle exec cars_api import \
  --car-store=crate-io \
  --crate-io-servers="crateio.example.org:4200" \
  --crate-io-car-table="production_cars" \
  /path/to/data.json
```

Full list of available options:

```bash
$ bundle exec cars_api help import
Usage:
  cars_api import FILE

Options:
  [--car-store=CAR_STORE]                    # CarStore adapter to use
                                             # Default: file-based
                                             # Possible values: in-memory, file-based, crate-io
  [--file-based-path=FILE_BASED_PATH]        # File based CarStore file path
                                             # Default: ./car_store.json
  [--crate-io-car-table=CRATE_IO_CAR_TABLE]  # Table name to store cars in
                                             # Default: cars_api_development_cars
  [--crate-io-servers=one two three]         # Servers to connect to for crate.io backed CarStore
                                             # Default: ["localhost:4200"]

Import car locations from JSON file
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
