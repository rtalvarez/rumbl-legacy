defmodule Rumbl.Repo.Migrations.AddCategoryToVideo do
  use Ecto.Migration

  def change do

    alter table(:videos) do
#      (TIP) The references function accepts :on_delete option, see docs
      add :category_id, references(:categories)
    end

  end
end
