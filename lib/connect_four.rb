class Game
	attr_accessor :board
	def initialize
		cols = [:a,:b,:c,:d,:e,:f,:g]
		@board = Hash.new
		cols.each do |col|
			@board[col] = [0,1,2,3,4,5]
		end
	end
end