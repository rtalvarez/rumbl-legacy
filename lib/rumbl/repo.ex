defmodule Rumbl.Repo do
  use Ecto.Repo, otp_app: :rumbl

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
  #  @moduledoc """
  #    In memory repository
  #  """
  #  def all(User) do
  #    [
  #      %User{id: "1", name: "Jose", username: "josevalim", password: "elixir"},
  #      %User{id: "2", name: "Bruce", username: "redrapids", password: "7langs"},
  #      %User{id: "3", name: "Chris", username: "chrismccord", password: "phx"}
  #    ]
  #  end
  #
  #  def all(_module) do
  #    []
  #  end
  #
  #  def get(module, id) do
  #    Enum.find(all(module), fn map -> map.id == id end)
  #  end
  #
  #  # TODO: Review
  #  def get_by(module, params) do
  #    Enum.find(all(module), fn map ->
  #      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
  #    end)
  #  end
end
