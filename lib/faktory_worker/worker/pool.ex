defmodule FaktoryWorker.Worker.Pool do
  use Supervisor

  alias FaktoryWorker.Random

  @spec start_link(opts :: keyword()) :: Supervisor.on_start()
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: format_worker_pool_name(opts))
  end

  @impl true
  def init(opts) do
    children =
      opts
      |> Keyword.get(:workers, [])
      |> Enum.map(&map_worker(&1, opts))
      |> List.flatten()

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp map_worker(worker_module, opts) do
    connection_opts = Keyword.get(opts, :connection, [])
    worker_opts = worker_module.worker_config()
    concurrency = Keyword.get(worker_opts, :concurrency, 1)
    disable_fetch = Keyword.get(worker_opts, :disable_fetch, false)

    Enum.reduce(1..concurrency, [], fn _, acc ->
      worker_id = Random.worker_id()
      worker_name = :"#{worker_module}_#{worker_id}"

      opts = [
        name: worker_name,
        connection: connection_opts,
        worker_id: worker_id,
        worker_module: worker_module,
        disable_fetch: disable_fetch
      ]

      [FaktoryWorker.Worker.Server.child_spec(opts) | acc]
    end)
  end

  def format_worker_pool_name(opts) do
    name = Keyword.get(opts, :name)
    :"#{name}_worker_pool"
  end
end
