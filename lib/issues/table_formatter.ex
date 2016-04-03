defmodule Issues.TableFormatter do

  def present(issues, headers) do
    widths = Enum.map(headers, &(calculate_column_width(issues, &1)))
    rows = Enum.map(issues, &(get_rows(&1, headers)))

    present_row(headers, widths)
    present_separation(widths)
    Enum.map(rows, &(present_row(&1, widths)))
  end

  def present_row(row, widths) do
    Enum.zip(row, widths)
    |> Enum.map(fn({value, length}) -> String.ljust(value, length) end)
    |> Enum.join(" | ")
    |> IO.puts
  end

  def present_separation(widths) do
    widths
    |> Enum.map(&(String.ljust("-", &1, ?-)))
    |> Enum.join("-+-")
    |> IO.puts
  end

  def get_rows(issue, headers) do
    Enum.map(headers, &("#{issue[&1]}"))
  end

  def calculate_column_width(issues, header) do
    issues
    |> Enum.map(&(calculate_item_width(&1, header)))
    |> Enum.concat([String.length(header)])
    |> Enum.max()
  end

  def calculate_item_width(issue, header) do
    "#{issue[header]}" |> String.length
  end
end
