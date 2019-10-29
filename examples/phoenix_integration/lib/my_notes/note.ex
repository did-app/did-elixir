defmodule MyNotes.Note do
  use Ecto.Schema

  schema "notes" do
    field :persona_id, :binary_id
    field :title, :string
    field :content, :string
    timestamps(type: :utc_datetime)
  end

  def changeset(note, attrs) do
    import Ecto.Changeset

    note
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
