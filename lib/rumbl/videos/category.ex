defmodule Rumbl.Videos.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Videos.Category
  import Ecto.Query

  schema "categories" do
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def alphabetical(query) do
    from(c in query, order_by: c.name)
  end

  def names_and_ids(query) do
    from(c in query, select: {c.name, c.id})
  end
end
