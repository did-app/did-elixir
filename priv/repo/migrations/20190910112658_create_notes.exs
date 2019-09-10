defmodule Knotes.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :persona_id, :binary_id, null: false
      add :title, :text, null: false
      add :content, :text, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:notes, :persona_id)
  end
end
