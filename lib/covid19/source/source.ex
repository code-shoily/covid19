defmodule Covid19.Source do
  @moduledoc """
  Functions to fetch data from source and updating the databases are here.
  """
  alias __MODULE__.CSSE.{Extract, Transform, Load}

  @doc """
  Data fetcher for JHU-CSSE data sources.

  Source: https://github.com/CSSEGISandData/COVID-19
  """
  def csse(date, type) do
    extract = (type == :us && (&Extract.us_data/1)) || (&Extract.global_data/1)

    date
    |> extract.()
    |> Transform.daily_data_to_map()
    |> Load.insert(type)
  end
end
