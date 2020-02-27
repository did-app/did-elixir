defmodule Kno.RequestError do
  defexception message: "Could not complete authentication, invalid request",
               actions: ["Do the thing"]
end

defimpl Plug.Exception, for: Kno.RequestError do
  def status(_) do
    400
  end
end
