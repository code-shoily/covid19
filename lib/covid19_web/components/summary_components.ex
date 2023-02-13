defmodule Covid19Web.SummaryComponents do
  use Phoenix.Component

  alias Covid19Web.Components.Helpers

  embed_templates "summary_templates/*"

  attr :data, :map, required: true
  def summary_card(assigns)

  defp get_filename(src) do
    src
    |> String.split("/")
    |> Enum.at(-1)
  end

  defp extract_link("data/covid19" <> rest) do
    "https://github.com/CSSEGISandData/COVID-19/blob/master" <> rest
  end
end
