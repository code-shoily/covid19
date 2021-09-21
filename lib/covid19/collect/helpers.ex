defmodule Covid19.Collect.Helpers do
  @moduledoc """
  A collection of helper functions to facilitate data collection from the covid19 repository
  """

  @typedoc """
  Represents a fully qualified path
  """
  @type path :: String.t()

  @typedoc """
  Resources are a map of date and the file resource for that date
  """
  @type resources :: %{required(Date.t()) => path()}

  @doc """
  Get directory for global data sources
  """
  @spec global_directory() :: path()
  def global_directory, do: get_directories()[:daily_dir]

  @doc """
  Get directory for US data sources
  """
  @spec us_directory() :: path()
  def us_directory, do: get_directories()[:daily_dir_us]

  defp get_directories, do: Application.get_env(:covid19, :data_source)

  @doc """
  Get resource map for global data
  """
  @spec global_resources() :: resources()
  def global_resources, do: global_directory() |> list_resources()

  @doc """
  Get resource map for US data
  """
  @spec us_resources() :: resources()
  def us_resources, do: us_directory() |> list_resources()

  defp list_resources(path) do
    path
    |> File.ls!()
    |> Enum.filter(&resource?/1)
    |> Enum.map(fn file ->
      {resource_to_date(file), Path.join(path, file)}
    end)
    |> Map.new()
  end

  defp resource_to_date(filename) do
    filename |> String.split(".") |> hd() |> to_iso8601!() |> Date.from_iso8601!()
  end

  defp resource?(filename) do
    filename
    |> String.split(".")
    |> hd()
    |> String.split("-")
    |> then(fn
      [_, _, _] -> true
      _ -> false
    end)
  end

  defp to_iso8601!(date) do
    date
    |> String.split("-")
    |> then(fn [month, day, year] -> "#{year}-#{month}-#{day}" end)
  end
end
