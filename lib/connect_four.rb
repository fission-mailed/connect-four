require 'colorize'

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
		@last_turn = nil
	end
	
	def num_to_sym(num)
		@cols[num]
	end
	
	def sym_to_num(sym)
		result = nil
		@cols.each_with_index do |col,index|
			if sym == col
				result = index
				break
			end
		end
		result
	end
	
	def get_cell_content(col_num,row)
		col = num_to_sym(col_num)
		content = @board[col][row]
	end
	
	def get_array_of_scores(arr)
		scores = []
		if arr.size >= 4
			i = 0
			while i < arr.size - 3
				sum = 0
				(i..i+3).each do |j|
					sum += get_cell_content(arr[j][0],arr[j][1])
				end
				scores.push(sum)
				i += 1
			end
		else
			scores.push(nil)
		end
		scores
	end
	
	def turn(player,col)
		if player == 1
			val = 1
		else
			val = -1
		end
		# if none of the slots in the column are 0, the column is full
		if @board[col].none? {|slot| slot == 0}
			return nil
		else
			@board[col].each_with_index do |slot,index|
				if slot == 0
					@board[col][index] = val
					@last_turn = [sym_to_num(col),index]
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
		@last_turn = nil
	end
	
	# when given a cell this method produces an array of all the cells
	# that are 3 cells away (or fewer if the cell is near an edge) in
	# the vertical, horizontal and both diagonal directions
	def get_ends(col_num,row)
		# get left end
		left_end = [0, col_num - 3].max
		west = [left_end, row]
		
		# get right end
		right_end = [col_num + 3, @width - 1].min
		east = [right_end, row]
		
		# get top end
		top_end = [row + 3, @height - 1].min
		north = [col_num, top_end]
		
		#get bottom end
		bottom_end = [0, row - 3].max
		south = [col_num, bottom_end]
		
		# get top-right end
		if col_num == right_end || row == top_end
			top_right_col = col_num
			top_right_row = row
		else
			next_col = col_num
			next_row = row
			# the top-right end can't exceed the right end or the top end
			until next_col + 1 > right_end || next_row + 1 > top_end
				next_col += 1
				next_row += 1
			end
			top_right_col = next_col
			top_right_row = next_row
		end
		north_east = [top_right_col, top_right_row]
		
		# get top-left end
		if col_num == left_end || row == top_end
			top_left_col = col_num
			top_left_row = row
		else
			prev_col = col_num
			next_row = row
			until prev_col - 1 < left_end || next_row + 1 > top_end
				prev_col -= 1
				next_row += 1
			end
			top_left_col = prev_col
			top_left_row = next_row
		end
		north_west = [top_left_col, top_left_row]
		
		# get bottom-left end
		if col_num == left_end || row == bottom_end
			bottom_left_col = col_num
			bottom_left_row = row
		else
			prev_col = col_num
			prev_row = row
			until prev_col - 1 < left_end || prev_row - 1 < bottom_end
				prev_col -= 1
				prev_row -= 1
			end
			bottom_left_col = prev_col
			bottom_left_row = prev_row
		end
		south_west = [bottom_left_col, bottom_left_row]
		
		# get bottom-right end
		if col_num == right_end || row == bottom_end
			bottom_right_col = col_num
			bottom_right_row = row
		else
			next_col = col_num
			prev_row = row
			until next_col + 1 > right_end || prev_row - 1 < bottom_end
				next_col += 1
				prev_row -= 1
			end
			bottom_right_col = next_col
			bottom_right_row = prev_row
		end
		south_east = [bottom_right_col, bottom_right_row]
		
		ends = [north, north_east, east, south_east, south, south_west, west, north_west]
	end
	
	# when given a starting cell and an ending cell, this method
	# returns an array of all the cells in between (inclusive) in a
	# straight line including horizontally, vertically and both diagonally
	# e.g. if given [0,0] and [0,3] would produce:
	# [[0,0],[0,1],[0,2],[0,3]]
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
	
	def score_space(col_num, row)
		scores = []
		ends = get_ends(col_num, row)
		
		# get all cells related to the current cell
		vert_span = traverse(ends[4],ends[0])
		horiz_span = traverse(ends[6],ends[2])
		sw_to_ne_span = traverse(ends[5],ends[1])
		nw_to_se_span = traverse(ends[7],ends[3])
		
		# get vertical scores
		get_array_of_scores(vert_span).each {|score| scores.push(score)}
		
		# get horizontal scores
		get_array_of_scores(horiz_span).each {|score| scores.push(score)}
		
		# get diagonal scores (sw->ne)
		get_array_of_scores(sw_to_ne_span).each {|score| scores.push(score)}
		
		# get diagonal scores (nw->se)
		get_array_of_scores(nw_to_se_span).each {|score| scores.push(score)}
		
		scores
	end
	
	# game is over when a player has connected 4 pieces or when the board if full.
	def game_over?
		if @last_turn == nil
			false
		else
			if score_space(@last_turn[0],@last_turn[1]).include?(4) || score_space(@last_turn[0],@last_turn[1]).include?(-4) || @turns == (@height * @width)
				true
			else
				false
			end
		end
	end
	
	def play
		quit = false
		until quit
			@exit = false
			reset
			puts
			puts "Welcome to Connect 4"
			puts
			puts "The aim of the game is to connect 4 of your pieces in a line,"
			puts "horizontally, vertically or diagonally, by dropping pieces into the grid."
			puts
			puts "Player 1, your pieces are red; Player 2, your pieces are blue."
			puts
			puts "Select the column you wish to drop your piece into by typing the letter A-G"
			puts
			puts "You can quit at any time by typing the word 'quit'"
			while @turns < 7 || game_over? == false
				display
				if @turns % 2 == 0
					player = 1
				else
					player = 2
				end
				repeat = true
				while repeat
					repeat = false
					puts "Player #{player} please select a column"
					input = gets.chomp.downcase.to_sym
					if input == :quit
						puts "You have decided to quit."
						@exit = true
						break
					end
					if @cols.include?(input) == false
						repeat = true
						puts "That was an invalid column input"
						puts "Please enter a b c d e f or g for column selection"
					elsif turn(player, input) == nil
						repeat = true
						puts "Column is full, select a different column."
					end
				end
				if @exit
					@turns = nil
					break
				end
			end
			display
			if @turns.nil? == false
				if @turns == 42
					puts "It's a draw!"
				elsif @turns % 2 != 0
					puts "Player 1 wins!"
				elsif @turns % 2 == 0
					puts "Player 2 wins!"
				end
			end

			puts "Do you want to play again?"
			answer = gets.chomp.downcase
			unless answer[0] == "y"
				quit = true
			end
		end
	end
	
	# displays the current state of the game board to the command line
	def display
		puts
		@cols .each do |header|
			print "   #{header.to_s.upcase}  "
		end
		puts
		(0..@height - 1).each do |row|
			(0..@width - 1).each do |col|
				print "|  #{token_colour(col,@height-row-1)}  "
			end
			puts "|"
			print " "
			(@width-1).times {print "-----+"}
			puts "----- "
		end
		puts
	end
	
	def token_colour(col_num, row)
		case get_cell_content(col_num, row)
		when 1
			token = "O".red
		when -1
			token = "O".blue
		else
			token = " "
		end
		token
	end
	
end
game = Game.new
game.play