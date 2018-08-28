class Game
	attr_accessor :board, :width, :height
	
	def initialize(width = 7, height = 6)
		@width = width
		@height = height
		@cols = [:a,:b,:c,:d,:e,:f,:g]
		@board = Hash.new
		@cols.each do |col|
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
	
	def get_ends(col,row)
		# get left limit
		left_end = [0, col - 3].max
		west = [left_end, row]
		
		# get right limit
		right_end = [col + 3, @width - 1].min
		east = [right_end, row]
		
		# get top limit
		top_end = [row + 3, @height - 1].min
		north = [col, top_end]
		
		#get bottom limit
		bottom_end = [0, row - 3].max
		south = [col, bottom_end]
		
		# get top right limit
		if col == right_end || row == top_end
			top_right_col = col
			top_right_row = row
		else
			next_col = col
			next_row = row
			# the top right limit can't exceed the right limit or the top limit
			until next_col + 1 > right_end || next_row + 1 > top_end
				next_col += 1
				next_row += 1
			end
			top_right_col = next_col
			top_right_row = next_row
		end
		north_east = [top_right_col, top_right_row]
		
		# get top left limit
		if col == left_end || row == top_end
			top_left_col = col
			top_left_row = row
		else
			prev_col = col
			next_row = row
			until prev_col - 1 < left_end || next_row + 1 > top_end
				prev_col -= 1
				next_row += 1
			end
			top_left_col = prev_col
			top_left_row = next_row
		end
		north_west = [top_left_col, top_left_row]
		
		# get bottom left limit
		if col == left_end || row == bottom_end
			bottom_left_col = col
			bottom_left_row = row
		else
			prev_col = col
			prev_row = row
			until prev_col - 1 < left_end || prev_row - 1 < bottom_end
				prev_col -= 1
				prev_row -= 1
			end
			bottom_left_col = prev_col
			bottom_left_row = prev_row
		end
		south_west = [bottom_left_col, bottom_left_row]
		
		# get bottom right limit
		if col == right_end || row == bottom_end
			bottom_right_col = col
			bottom_right_row = row
		else
			next_col = col
			prev_row = row
			until next_col + 1 > right_end || prev_row - 1 < bottom_end
				next_col += 1
				prev_row -= 1
			end
			bottom_right_col = next_col
			bottom_right_row = prev_row
		end
		south_east = [bottom_right_col, bottom_right_row]
		
		limits = [north, north_east, east, south_east, south, south_west, west, north_west]
	end
	
	def traverse(start, finish)
		verts = []
		horiz = []
		diag_ne = []
		diag_se = []
		# corner cases
		if start[0] == finish[0] && start[1] == finish[1]
			if start == [0,0]
				diag_se.push([0,0])
				return diag_se
			elsif start == [0, @height-1]
				diag_ne.push([0, @height-1])
				return diag_ne
			elsif start == [@width-1, @height-1]
				diag_se.push([@width-1, @height-1])
				return diag_se
			else
				diag_ne.push([@width-1, 0])
				return diag_ne
			end
		# cells on the same column
		elsif start[0] == finish[0]
			i = start[0]
			j = start[1]
			until j > finish[1]
				verts.push([i,j])
				j += 1
			end
			return verts
		# cells on the same row
		elsif start[1] == finish[1]
			i = start[0]
			j = start[1]
			until i > finish[0]
				horiz.push([i,j])
				i += 1
			end
			return horiz
		# cells along sw -> ne diagonal 
		elsif start[0] < finish[0] && start[1] < finish[1]
			i = start[0]
			j = start[1]
			until i > finish[0] || j > finish[1]
				diag_ne.push([i,j])
				i += 1
				j += 1
			end
			return diag_ne
		# cells along nw -> se diagonal
		elsif start[0] < finish[0] && start[1] > finish[1]
			i = start[0]
			j = start[1]
			until i > finish[0] || j < finish[1]
				diag_se.push([i,j])
				i += 1
				j -= 1
			end
			return diag_se
		end
	end
	
	def score_space(col,row)
		score = []
		col_index = 0
		@cols.each_with_index do |item, index|
			if col == item
				col_index = index
			end
		end
		limits = get_ends(col_index, row)
		verts = traverse(limits[4],limits[0])
		verts.each_with_index do |cell,index|
			#unless verts.size - 
		end
	end
	
	def game_over?
		true
	end
	
	def play
	end
	
end