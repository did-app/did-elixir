defmodule MyNotesWeb.PageController do
  use MyNotesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
