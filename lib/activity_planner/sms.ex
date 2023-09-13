defmodule ActivityPlanner.SMS do
  @clicksend_api "https://rest.clicksend.com/v3/sms/send"

  def send_sms(to, message) do
    if Application.get_env(:activity_planner, :clicksend)[:enabled] do
      from_name = Application.get_env(:activity_planner, :clicksend)[:from_name]
      api_key = Application.get_env(:activity_planner, :clicksend)[:api_key]
      username = Application.get_env(:activity_planner, :clicksend)[:username]

      body = Jason.encode!(%{
        "messages" => [
          %{
            "source" => "elixir",
            "from" => from_name,
            "body" => message,
            "to" => to
          }
        ]
      })

      headers = [
        {"Authorization", "Basic " <> :base64.encode(username <>":" <> api_key)},
        {"Content-Type", "application/json"}
      ]

      case HTTPoison.post(@clicksend_api, body, headers) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, body}
        {:ok, %HTTPoison.Response{status_code: status_code}} ->
          {:error, "Received status code #{status_code}"}
        {:error, %HTTPoison.Error{reason: reason}} ->
          {:error, "HTTP error: #{reason}"}
      end
    else
      IO.puts("SMS sending is disabled.")
      {:ok, "SMS sending is disabled."}
    end
  end
end
