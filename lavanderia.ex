defmodule Maquina do
  @moduledoc """
  Behaviour de uma maquina comum na Lavanderia
  """
  @callback ligar(term) :: {:ok, term} | {:error, String.t}
  @callback desligar(term) :: {:ok, term} | {:error, String.t}
  @callback duration() :: Integer.t
end

defmodule Lavadora do
  @moduledoc """
  Modulo que define a lavadora
  """
  @behaviour Maquina

  use GenServer

  @impl true
  @doc """
  Duracao da lavagem.
  """
  def duration() do
    3_000
  end

  def start_link(%{washer_name: _washer_name, name: _name} = opts) do
    GenServer.start_link(__MODULE__, opts, name: opts.name)
  end

  @impl true
  def init(opts) do
    {:ok, Map.put(opts, :status, :off)}
  end

  @impl true
  def handle_call(:ligar, _from, state) do
    with {:ok, state} = data <- ligar(%{state: state, washer: self()}) do
      {:reply, data, state}
    else
      error -> {:reply, error, state}
    end
  end

  @impl true
  def handle_info(:desligar, state) do
    with {:ok, state} <- desligar(%{state: state, washer: self()}) do
      IO.inspect state
      {:noreply, state}
    else
      _ -> {:noreply, state}
    end
  end

  @impl true
  def desligar(%{state: state, washer: _washer}) do
    case state.status do
      :on ->
        state = %{state | status: :off}
        {:ok, state}
    end
  end

  @impl true
  def ligar(%{state: current, washer: washer}) do
    case current.status do
      :off ->
        current = %{current | status: :on}
        Process.send_after(washer, :desligar, duration())
        {:ok, current}
      :on ->
        {:error, "Maquina ja esta ligada."}
    end
  end
end
