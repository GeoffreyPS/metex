defmodule Metex.Worker do

	## Client API

	def start_link(opts \\ []) do
		GenServer.start_link(__MODULE__, :ok, opts)
	end

	## Server Callbacks

	def init(:ok) do
		{:ok, %{}}
	end

	## Helper Functions

end