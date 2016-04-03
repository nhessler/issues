defmodule TableFormatterTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  def sample_data do
    [%{c1: "r1++c1", c2: "r1 c2",   c3: "r1 c3",    c4: "r1 c4"},
     %{c1: "r2 c1",  c2: "r2+++c2", c3: "r2 c3",    c4: "r2 c4"},
     %{c1: "r3 c1",  c2: "r3 c2",   c3: "r3++++c3", c4: "r3 c4"},
     %{c1: "r4 c1",  c2: "r4 c2",   c3: "r4 c3",    c4: "r4+++++c4"}]
  end

  def headers, do: [:c1, :c2, :c4]

  test "calculating column width" do
    assert TF.calculate_column_width(sample_data, :c4) == 9
  end

  test "getting row" do
    expected = ["r1++c1", "r1 c2", "r1 c4"]
    assert TF.get_columns(hd(sample_data), headers) == expected
  end

  test "presentation is correct" do
    result = capture_io fn -> TF.present(sample_data, headers) end
    assert result == """
    c1     | c2      | c4
    -------+---------+----------
    r1++c1 | r1 c2   | r1 c4
    r2 c1  | r2+++c2 | r2 c4
    r3 c1  | r3 c2   | r3 c4
    r4 c1  | r4 c2   | r4+++++c4
    """
  end
end
