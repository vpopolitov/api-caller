module Enumerable
  def to_symbol_arr
    self.map(&:intern).to_a
  end
end