defmodule Metex.Worker do
	use GenServer

	## Client API

	def start_link(opts \\ []) do
		GenServer.start_link(__MODULE__, :ok, opts)
	end

	def get_temperature(pid, location) do
		GenServer.call(pid, {:location, location})
	end
	## Server API

	def init(:ok) do
		{:ok, %{}}
	end

	## Helper Functions

end