defmodule Covid19Web.SummaryComponent do
  @moduledoc false

  use Covid19Web, :surface_component

  prop data, :list

  defp get_filename(src) do
    src |> String.split("/") |> Enum.at(-1)
  end

  defp extract_link("data/covid19" <> rest) do
    "https://github.com/CSSEGISandData/COVID-19/blob/master" <> rest
  end
end
