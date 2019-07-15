defmodule FaktoryWorker.EventLogger do
  @moduledoc """
  Handles all of the Telemetry events emitted by Faktory Worker and outputs a log message
  when receiving an event.
  """

  require Logger

  @events [:push, :beat, :fetch, :ack, :failed_ack]

  @doc """
  Attaches the `FaktoryWorker.EventLogger` to Telemetry.

  Once attached Faktory Worker will start outputting log messages using the `Logger` module for
  each event emitted.

  For a full list of events see the [Logging](logging.html) documentation.
  """
  @spec attach :: :ok | {:error, :already_exists}
  def attach() do
    events = Enum.map(@events, &[:faktory_worker, &1])

    :telemetry.attach_many(:faktory_worker_logger, events, &__MODULE__.handle_event/4, [])
  end

  @doc false
  def handle_event([:faktory_worker, event], measurements, metadata, _config) do
    log_event(event, measurements, metadata)
  end

  # Push events

  defp log_event(:push, %{status: :ok}, job) do
    log_info("Enqueued", job.jid, job.args, job.jobtype)
  end

  defp log_event(:push, %{status: {:error, :not_unique}}, job) do
    log_info("NOTUNIQUE", job.jid, job.args, job.jobtype)
  end

  # Beat events

  # no state change, status == status
  defp log_event(:beat, %{status: status}, %{prev_status: status}) do
    :ok
  end

  defp log_event(:beat, %{status: :ok}, %{wid: wid}) do
    log_info("Heartbeat Succeeded", wid)
  end

  defp log_event(:beat, %{status: :error}, %{wid: wid}) do
    log_info("Heartbeat Failed", wid)
  end

  # Fetch events

  defp log_event(:fetch, %{status: {:error, reason}}, %{wid: wid}) do
    log_info("Failed to fetch job due to '#{reason}'", wid)
  end

  # Acks

  defp log_event(:ack, %{status: :ok}, job) do
    log_info("Succeeded", job.jid, job.args, job.jobtype)
  end

  defp log_event(:ack, %{status: :error}, job) do
    log_info("Failed", job.jid, job.args, job.jobtype)
  end

  # Failed acks

  defp log_event(:failed_ack, %{status: :ok}, job) do
    log_info("Error sending 'ACK' acknowledgement to faktory", job.jid, job.args, job.jobtype)
  end

  defp log_event(:failed_ack, %{status: :error}, job) do
    log_info("Error sending 'FAIL' acknowledgement to faktory", job.jid, job.args, job.jobtype)
  end

  # Log formats

  defp log_info(message) do
    Logger.info("[faktory-worker] #{message}")
  end

  defp log_info(outcome, wid) do
    log_info("#{outcome} wid-#{wid}")
  end

  defp log_info(outcome, jid, args, worker_module) do
    log_info("#{outcome} (#{worker_module}) jid-#{jid} #{inspect(args)}")
  end
end
