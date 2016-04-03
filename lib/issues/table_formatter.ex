defmodule Issues.TableFormatter do

  def present(issues, headers) do
    widths = Enum.map(headers, &(calculate_column_width(issues, &1)))
    rows = Enum.map(issues, &(get_columns(&1, headers)))

    present_row(headers, widths)
    present_separation(widths)
    Enum.map(rows, &(present_row(&1, widths)))
  end

  def present_row(row, widths) do
    Enum.zip(row, widths)
    |> Enum.map(fn({value, length}) -> String.ljust(to_string(value), length) end)
    |> Enum.join(" | ")
    |> String.strip
    |> IO.puts
  end

  def present_separation(widths) do
    widths
    |> Enum.map(&(List.duplicate("-", &1)))
    |> Enum.join("-+-")
    |> IO.puts
  end

  def get_columns(issue, headers) do
    Enum.map(headers, &(to_string(issue[&1])))
  end

  def calculate_column_width(issues, header) do
    issues
    |> Enum.map(&(calculate_item_width(&1, header)))
    |> Enum.concat([String.length(to_string(header))])
    |> Enum.max()
  end

  def calculate_item_width(issue, header) do
    to_string(issue[header]) |> String.length
  end
end
