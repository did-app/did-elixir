defmodule MyNotes.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :persona_id, :binary_id, null: false
      add :title, :text, null: false
      add :content, :text, null: false
      timestamps(type: :utc_datetime)
    end

    create index(:notes, :persona_id)
  end
end
