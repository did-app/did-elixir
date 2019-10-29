defmodule MyNotesWeb.NoteController do
  use MyNotesWeb, :controller

  def index(conn, _params) do
    %{persona_id: persona_id} = conn.assigns

    notes = MyNotes.list_notes(persona_id)
    render(conn, "index.html", notes: notes)
  end

  def new(conn, _params) do
    %{persona_id: persona_id} = conn.assigns

    changeset = MyNotes.change_note(%MyNotes.Note{persona_id: persona_id})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"note" => note_params}) do
    %{persona_id: persona_id} = conn.assigns

    case MyNotes.create_note(note_params, persona_id) do
      {:ok, note} ->
        conn
        |> put_flash(:info, "Note created successfully.")
        |> redirect(to: Routes.note_path(conn, :show, note))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    %{persona_id: persona_id} = conn.assigns

    note = MyNotes.get_note!(id, persona_id)
    render(conn, "show.html", note: note)
  end

  def edit(conn, %{"id" => id}) do
    %{persona_id: persona_id} = conn.assigns

    note = MyNotes.get_note!(id, persona_id)
    changeset = MyNotes.change_note(note)
    render(conn, "edit.html", note: note, changeset: changeset)
  end

  def update(conn, %{"id" => id, "note" => note_params}) do
    %{persona_id: persona_id} = conn.assigns

    note = MyNotes.get_note!(id, persona_id)

    case MyNotes.update_note(note, note_params) do
      {:ok, note} ->
        conn
        |> put_flash(:info, "Note updated successfully.")
        |> redirect(to: Routes.note_path(conn, :show, note))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", note: note, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    %{persona_id: persona_id} = conn.assigns

    note = MyNotes.get_note!(id, persona_id)
    {:ok, _note} = MyNotes.delete_note(note)

    conn
    |> put_flash(:info, "Note deleted successfully.")
    |> redirect(to: Routes.note_path(conn, :index))
  end
end
