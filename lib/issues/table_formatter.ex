defmodule Issues.TableFormatter do

  @doc """
  Take a list of row data, where each row is a Map, and a list of headers. Prints a table to STDOUT of the data of each row identified by each header. That is each header identifies a column, and those columns are extracted and printed from the rows

  We calculate the width of each column to fit the longest element in that column.
  """
  def present(issues, headers) do
    widths = Enum.map(headers, &(calculate_column_width(issues, &1)))
    rows   = Enum.map(issues, &(get_columns(&1, headers)))
    table  = [present_row(headers, widths),
              present_separation(widths) |
              Enum.map(rows, &(present_row(&1, widths)))]

    table |> Enum.each(&IO.puts/1)
  end

  @doc """
  Takes a row and a list of column widths and prints that row to STDOUT

  ## Example
      iex> [row, widths] = [["c1", "c2", "c3"], [3, 5, 7]]
      iex> Issues.TableFormatter.present_row(row, widths)
      "c1  | c2    | c3"
  """
  def present_row(row, widths) do
    Enum.zip(row, widths)
    |> Enum.map(fn({value, length}) -> String.ljust(to_string(value), length) end)
    |> Enum.join(" | ")
    |> String.strip
  end

  @doc """
  Given a list of column widths will print to STDOUT a seperating line of correct column widths

  ## Example
      iex> Issues.TableFormatter.present_separation([3,5,7])
      "----+-------+--------"
  """
  def present_separation(widths) do
    widths
    |> Enum.map(&(List.duplicate("-", &1)))
    |> Enum.join("-+-")
  end

  @doc """
  Takes a Map and list of headers and returns a list of values mapped to the headers

  ## Example
      iex> Issues.TableFormatter.get_columns(%{h1: "v1", h2: "v2", h3: "v3" }, [:h1, :h3])
      ["v1", "v3"]
  """
  def get_columns(issue, headers) do
    Enum.map(headers, &(to_string(issue[&1])))
  end

  @doc """
  Given a List of row data, where each row is a Map, and a key. Returns the max length of those values and header combined

  ## Example
      iex> rows = [%{c1: "1"}, %{c1: "12"}, %{c1: "123"}]
      iex> Issues.TableFormatter.calculate_column_width(rows, :c1)
      3
  """
  def calculate_column_width(issues, header) do
    issues
    |> Enum.map(&(calculate_item_width(&1, header)))
    |> Enum.concat([String.length(to_string(header))])
    |> Enum.max()
  end

  @doc """
  given a Map and a key. returns the length of the value tied to that key

  ## Example
      iex> map = %{user: "nathan", project: "issues", book: "programming-elixir"}
      iex> Issues.TableFormatter.calculate_item_width(map, :user)
      6
  """
  def calculate_item_width(issue, header) do
    to_string(issue[header]) |> String.length
  end
end
