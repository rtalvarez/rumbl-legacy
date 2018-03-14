defmodule Rumbl.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:username, :string)
    # Virtual fields are not persisted in DB
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    has_many(:videos, Rumbl.Videos.Video)

    timestamps()
  end

  def changeset(model, params \\ :empty) do
    # TODO: Diff syntax on guide -> cast(params, [:name, :username])
    model
    |> cast(params, ~w(name username), [])
    |> validate_required(~w(name username)a)
    |> validate_length(:username, min: 1, max: 20)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
