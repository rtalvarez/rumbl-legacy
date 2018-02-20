defmodule Rumbl.User do
#  use RumblWeb, :model
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true # Virtual fields are not persisted in DB
    field :password_hash, :string

    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username), []) #TODO: Diff syntax on guide -> cast(params, [:name, :username])
    |> validate_length(:username, min: 1, max: 20)
  end
end
