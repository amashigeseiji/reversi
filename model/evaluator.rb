class Evaluator
  def initialize(board_id)
    @board_id = board_id
    @default = 'move'
  end

  def evaluate(strategy = nil)
    strategy(strategy).evaluate(Board.instance(@board_id))
  end

  def strategy(strategy = nil)
    strategy ||= @default
    if !@strategy || @strategy.class.to_s.underscore != strategy
      @strategy = Strategy.factory(strategy)
    end
    @strategy
  end
end