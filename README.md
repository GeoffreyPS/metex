# metex
Weather reporting app with message processing from the Little Elixir and OTP Guidebook

## Setup
### Install Elixir
Follow directions to [install Elixir](http://elixir-lang.org/install.html) for your machine. For Mac OSX, `brew install elixir` should do the trick.

This might take a minute, as the entire Erlang langauge is a dependency. 

### Clone this repo into a working directory
In the command line, navigate to a workind directory and run the command `git clone git@github.com:GeoffreyPS/metex.git`

### Fetch Dependencies
From the command line, cd into your new directory and run `mix deps.get` to grab all of the necessary dependencies. The first time through, you may be prompted to install [Hex](https://hex.pm/), the package manager for Elixir/Erlang projects. You will need Hex to manage the dependencies.

### Get API Key
Metex uses the Open Weather Map API to fetch weather information. After this example was created, Open Weather Map required its users to register to receive an API key. [Sign up for the key](https://home.openweathermap.org/users/sign_up) and then add your key to `mix.exs`. The area should look like this:
`config :metex, open_weather_app_id: "" #ADD API KEY HERE. GET API KEY FROM https://home.openweathermap.org/users/sign_up`

## Usage
From the command line, run `iex -S mix` to compile the project and start the Elixir REPL. Compilation may take a few moments the first time through ([learn more about iex here](http://elixir-lang.org/docs/stable/iex/IEx.html)).

Once we're fired up, you should see something like this:

```
Erlang/OTP 18 [erts-7.2.1] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.2.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> 
```
Your REPL is up and running! Let's start a worker so we can start checking the weather.

```
iex(1)> Metex.Worker.start_link 	#start a worker process
{:ok, #PID<0.149.0>} 							#receive a tuple with message :ok, and the process ID (your number might be different)
```

Let's have our worker get the temperatures from our favorite places:
```
iex(2)> Metex.Worker.get_temperature "Houston"
"24.0°C"
iex(3)> Metex.Worker.get_temperature "Chicago"
"13.0°C"
iex(4)> Metex.Worker.get_temperature "Berlin"
"0.0°C"
iex(5)> Metex.Worker.get_temperature "Singapore"
"28.0°C"
iex(6)> Metex.Worker.get_temperature "Tokyo"
"10.0°C"
iex(7)> Metex.Worker.get_temperature "Houston"
"24.0°C"
```
If we want to check the state of what our worker has, we can use the `get_stats` function:
```
iex(8)> Metex.Worker.get_stats
%{"Berlin" => 1, "Chicago" => 1, "Houston" => 2, "Singapore" => 1, "Tokyo" => 1}
```
The function returns a map with each city queried, plus the frequency of requests.

We can also clear the state with `reset_stats`:
```
iex(9)> Metex.Worker.reset_stats
:ok
iex(10)> Metex.Worker.get_stats
%{}
```

Gracefully terminate the process by telling the worker to `stop`.
```
iex(11)> Metex.Worker.stop
Server terminated because of :normal
:ok
```
Exit BEAM by hitting ctrl + C and then pressing `a` followed by Enter (or hit ctrl + C twice).

## Explanation
Take a look at lib/worker.ex to see the bulk of our functions. The worker uses the GenServer OTP pattern, which comes baked-in with Elixir if specified. We only need to implement the functions for the GenServer API. You can see those within the Callbacks section of the functions within worker.ex. 