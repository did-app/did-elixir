defmodule Kno.RequestError do
  defexception message: "Could not complete authentication, invalid request",
               actions: ["Doth ethe thing"]
end

defimpl Plug.Exception, for: Kno.RequestError do
  def status(_) do
    400
  end
end
