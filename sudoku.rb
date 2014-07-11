class Game
  attr_reader :board

  def initialize(file = ARGF)
    @board = file.read.scan(/[0-9]|_/).map(&:to_i)
  end

  def solve(index = 0)
    (1..9).each do |number|
      f = board[index]
      next if (f != 0 && f != number) || taken(index, number)
      board[index] = number
      return true if index == 80 || solve(index + 1)
      board[index] = f
    end
    false
  end

  private

  def neighbour?(i, j)
    box = lambda {|n| n / 27 * 3 + n % 9 / 3}
    (i != j) && (i / 9 == j / 9 || i % 9 == j % 9 || box[i] == box[j])
  end

  def neighbours
    @neighbours ||= (0..80).map {|i| (0..80).select {|j| neighbour?(i, j)}}
  end

  def taken(index, number)
    neighbours[index].any? {|i| board[i] == number}
  end
end

game = Game.new
game.solve
puts game.board.each_slice(9).map{|s| s.join(' ')}

