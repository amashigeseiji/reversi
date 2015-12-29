class Move
  attr_reader :cell

  def initialize(index, turn, board_id)
    @turn = turn
    @board_id = board_id
    @cell = board.cells[index]
  end

  def execute
    @cell.set(@turn)
    reversibles.each do |cell|
      cell.reverse
    end
    board.next_turn
  end

  def simulate(&block)
    Simulator.simulate(@board_id) do |board|
      board.moves[@cell.index].execute
      yield board
    end
  end

  def executable?
    !reversibles.empty?
  end

  def reversibles
    return @reversibles if @reversibles
    @reversibles = []
    next_cells.each do |next_cell|
      reversible_line(@cell.vector_to(next_cell)).each do |reversible|
        @reversibles << reversible
      end
    end
    @reversibles
  end

  def index
    @cell.index
  end

  private

  def next_cells
    return @next_cells if @next_cells
    @next_cells = []
    Cell.vectors.each do |vector|
      next_cell = @cell.next_cell(vector)
      @next_cells << next_cell if next_cell && next_cell.opposite_to?(@turn)
    end
    @next_cells
  end

  def reversible_line(vector)
    next_cell = @cell.next_cell(vector)
    cells = [next_cell]
    while true do
      #同じ方向の次のセルを取得
      next_cell = next_cell.next_cell(vector)
      if !next_cell || !next_cell.filled?
        #次のセルが存在しないまたは値がない場合は値をリセット
        cells = []
        break
      end

      if next_cell.opposite_to?(@turn)
        #指し手と色が違う場合は配列に入れる
        cells << next_cell
      else
        break
      end
    end
    cells
  end

  def board
    Board.instance(@board_id)
  end
end
