defmodule Knotes.Notes do
  @moduledoc """
  The Notes context.
  """

  import Ecto.Query, warn: false

  alias Knotes.Notes.Note
  alias Knotes.Repo

  @doc """
  Returns the list of notes for a given persona id.
  """
  def list_notes(persona_id) when is_binary(persona_id) do
    from(n in Note, where: n.persona_id == ^persona_id, order_by: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single note owned by a persona.
  """
  def get_note!(id, persona_id), do: Repo.get_by!(Note, id: id, persona_id: persona_id)

  @doc """
  Creates a note for a persona.
  """
  def create_note(attrs, persona_id) do
    %Note{persona_id: persona_id}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an existing note.
  """
  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Note.
  """
  def delete_note(%Note{} = note) do
    Repo.delete(note)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note changes.
  """
  def change_note(%Note{} = note) do
    Note.changeset(note, %{})
  end
end
