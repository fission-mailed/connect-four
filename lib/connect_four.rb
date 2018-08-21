class Game
	attr_accessor :board
	
	def initialize
		cols = [:a,:b,:c,:d,:e,:f,:g]
		@board = Hash.new
		cols.each do |col|
			@board[col] = [0,0,0,0,0,0]
		end
		@turns = 0
	end
	
	def turn(player,col)
		if player == 1
			val = 1
		else
			val = -1
		end
		# if none of the slots in the column are 0, the column is full
		if @board[col].none? {|slot| slot == 0}
			puts "Column is full, choose a different column."
			return nil
		else
			@board[col].each_with_index do |slot,index|
				if slot == 0
					@board[col][index] = val
					break
				end
			end
		end
		
		@turns += 1
	end
	
	def reset
		@board.each do |key,val|
			@board[key] = [0,0,0,0,0,0]
		end
		@turns = 0
	end
	
	def game_over?
		true
	end
	
end