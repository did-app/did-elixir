defmodule KnotesWeb.NoteController do
  use KnotesWeb, :controller
  use KnotesWeb.AuthenticatedController

  alias Knotes.Notes
  alias Knotes.Notes.Note

  plug(KnotesWeb.Plug.EnsureAuthenticated)

  def index(conn, _params, persona_id) do
    notes = Notes.list_notes(persona_id)
    render(conn, "index.html", notes: notes)
  end

  def new(conn, _params, persona_id) do
    changeset = Notes.change_note(%Note{persona_id: persona_id})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"note" => note_params}, persona_id) do
    case Notes.create_note(note_params, persona_id) do
      {:ok, note} ->
        conn
        |> put_flash(:info, "Note created successfully.")
        |> redirect(to: Routes.note_path(conn, :show, note))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, persona_id) do
    note = Notes.get_note!(id, persona_id)
    render(conn, "show.html", note: note)
  end

  def edit(conn, %{"id" => id}, persona_id) do
    note = Notes.get_note!(id, persona_id)
    changeset = Notes.change_note(note)
    render(conn, "edit.html", note: note, changeset: changeset)
  end

  def update(conn, %{"id" => id, "note" => note_params}, persona_id) do
    note = Notes.get_note!(id, persona_id)

    case Notes.update_note(note, note_params) do
      {:ok, note} ->
        conn
        |> put_flash(:info, "Note updated successfully.")
        |> redirect(to: Routes.note_path(conn, :show, note))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", note: note, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, persona_id) do
    note = Notes.get_note!(id, persona_id)
    {:ok, _note} = Notes.delete_note(note)

    conn
    |> put_flash(:info, "Note deleted successfully.")
    |> redirect(to: Routes.note_path(conn, :index))
  end
end
