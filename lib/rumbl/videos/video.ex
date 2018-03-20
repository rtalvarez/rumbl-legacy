defmodule Rumbl.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Videos.Video

  schema "videos" do
    field(:url, :string)
    field(:description, :string)
    field(:title, :string)
    #    field :user_id, :id
    belongs_to(:user, Rumbl.Users.User)
    belongs_to(:category, Rumbl.Videos.Category)

    timestamps()
  end

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description, :category_id, :user_id])
    |> validate_required([:url, :title, :description])
    |> assoc_constraint(:category)
  end
end
