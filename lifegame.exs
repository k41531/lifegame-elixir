defmodule LifeGame do
  @height 32
  @width 32

  def create_universe() do
    matrix = Enum.map(
      1..@height, fn _ -> Enum.map(
        1..@width, fn _ -> :rand.uniform() <= 0.5
      end)
    end)
    matrix
  end

  def clear() do
    IO.puts "\e[H\e[2J"
  end

  def liveNeighborCount(row, col, matrix) do
    Enum.count(Enum.slice(Enum.at(matrix,row-1),col-1, 3), fn x -> x end) +
    Enum.count(Enum.slice(Enum.at(matrix,rem((row+1),@width)),col-1, 3), fn x -> x end) +
    if(Enum.at(Enum.at(matrix,row),col-1), do: 1, else: 0)+
    if(Enum.at(Enum.at(matrix,row),col+1), do: 1, else: 0)
  end

  def update(matrix) do
     Enum.map(0..@height-1, fn row ->
      Enum.map(0..@width-1, fn col ->
          case liveNeighborCount(row,col,matrix) do
            n when n < 2 or 3 < n -> false
            n when n == 3  -> true
            _ -> Enum.at(Enum.at(matrix,row),col)
          end
        end)
      end)
  end

  def display(matrix) do
    IO.puts(
      Enum.join(
        Enum.map(matrix, fn row ->
          Enum.join(
            Enum.map(
              row, fn cell -> if cell, do: "🟩", else: "⬜️" end), "") end), "\n"))
  end

  def main(matrix) do
    clear()
    display(matrix)
    :timer.sleep(500)
    main(update(matrix))
  end
end

matrix = LifeGame.create_universe()
LifeGame.main(matrix)
