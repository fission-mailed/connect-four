require "connect_four"

describe "Game" do
	obj = Game.new
	it "the game board should be 7x6" do
		
		def board_size(obj)
			size = 0
			obj.board.each do |col, row|
				size += row.size
			end
			size
		end
		expect(board_size(obj)).to eq(42)
	end
	
	context "num_to_sym and sym_to_num methods" do
		it "should convert numbered columns to symbol column names" do
			expect(obj.num_to_sym(0)).to eq(:a)
			expect(obj.num_to_sym(1)).to eq(:b)
			expect(obj.num_to_sym(2)).to eq(:c)
			expect(obj.num_to_sym(3)).to eq(:d)
			expect(obj.num_to_sym(4)).to eq(:e)
			expect(obj.num_to_sym(5)).to eq(:f)
			expect(obj.num_to_sym(6)).to eq(:g)
		end
		it "should convert symbol column names to numbered columns" do
			expect(obj.sym_to_num(:a)).to eq(0)
			expect(obj.sym_to_num(:b)).to eq(1)
			expect(obj.sym_to_num(:c)).to eq(2)
			expect(obj.sym_to_num(:d)).to eq(3)
			expect(obj.sym_to_num(:e)).to eq(4)
			expect(obj.sym_to_num(:f)).to eq(5)
			expect(obj.sym_to_num(:g)).to eq(6)
			expect(obj.sym_to_num(:h)).to be nil
		end
	end
	
	it "should fill the 'cage' from the bottom up" do
		obj.turn(1,:a)
		obj.turn(1,:a)
		obj.turn(2,:a)
		obj.turn(1,:a)
		obj.turn(2,:a)
		obj.turn(1,:a)
		expect(obj.board[:a][0]).to eq(1)
		expect(obj.board[:a][1]).to eq(1)
		expect(obj.board[:a][2]).to eq(-1)
		expect(obj.board[:a][4]).to eq(-1)
		expect(obj.turn(2,:a)).to be nil
		expect(obj.board[:b][0]).to eq(0)	
	end
	
	it "should reset the board when the reset method is called" do
		obj.reset
		expect(obj.board[:a][0]).to eq(0)
		expect(obj.board[:a][3]).to eq(0)
	end
	
	it "get_ends method should produce an array of 8 points" do
		limits = obj.get_ends(3,3)
		expect(limits.size).to eq(8)
		expect(limits).to eq([[3,5],[5,5],[6,3],[6,0],[3,0],[0,0],[0,3],[1,5]])
		limits = obj.get_ends(0,0)
		expect(limits).to eq([[0,3],[3,3],[3,0],[0,0],[0,0],[0,0],[0,0],[0,0]])
	end
	
	context "traverse should keep track of all 'related' cells" do
		it "should check horizontal cells" do
			horiz = obj.traverse([0,0],[3,0])
			expect(horiz).to eq([[0,0],[1,0],[2,0],[3,0]])
		end
		it "should check vertical cells" do
			vert = obj.traverse([5,2],[5,5])
			expect(vert).to eq([[5,2],[5,3],[5,4],[5,5]])
		end
		it "should check sw->ne diagonal" do
			diag = obj.traverse([2,3],[4,5])
			expect(diag).to eq([[2,3],[3,4],[4,5]])
		end
		it "should check nw->se diagonal" do
			diag = obj.traverse([4,3],[6,1])
			expect(diag).to eq([[4,3],[5,2],[6,1]])
		end
		it "should work for corner cases" do
			corner = obj.traverse([0,0],[0,0])
			expect(corner).to eq([[0,0]])
			corner = obj.traverse([0,5],[0,5])
			expect(corner).to eq([[0,5]])
			corner = obj.traverse([6,5],[6,5])
			expect(corner).to eq([[6,5]])
			corner = obj.traverse([6,0],[6,0])
			expect(corner).to eq([[6,0]])
		end
	end

	
	context "get_ends and traverse work together" do
		limits = obj.get_ends(2,2)
		horiz = obj.traverse(limits[6],limits[2])
		vert = obj.traverse(limits[4],limits[0])
		diag_ne = obj.traverse(limits[5],limits[1])
		diag_se = obj.traverse(limits[7],limits[3])
		it "should get horizontal cells" do
			expect(horiz).to eq([[0,2],[1,2],[2,2],[3,2],[4,2],[5,2]])
		end
		it "should get vertical cells" do
			expect(vert).to eq([[2,0],[2,1],[2,2],[2,3],[2,4],[2,5]])
		end
		it "should get sw->ne diagonal cells" do
			expect(diag_ne).to eq([[0,0],[1,1],[2,2],[3,3],[4,4],[5,5]])
		end
		it "should get nw->se diagonal cells" do
			expect(diag_se).to eq([[0,4],[1,3],[2,2],[3,1],[4,0]])
		end
	end
	
	context "get_cell_content" do
		it "should get content of a cell from a numerical cell input" do
			obj.reset
			expect(obj.get_cell_content(3,0)).to eq(0)
			obj.turn(1,:d)
			expect(obj.get_cell_content(3,0)).to eq(1)
			obj.turn(2,:a)
			expect(obj.get_cell_content(0,0)).to eq(-1)
		end
	end


	context "score_space method" do
		it "should return array of up to 13 scores" do
			obj.reset
			expect(obj.score_space(3,3).size).to be <= 13
		end
		it "should produce an array of zeros at the start" do
			expect(obj.score_space(3,3)).to eq([0,0,0,0,0,0,0,0,0,0,0,0,0])
		end
		it "should produce the correct score after several turns" do
			obj.turn(1,:b)
			obj.turn(2,:b)
			obj.turn(1,:b)
			obj.turn(2,:b)
			expect(obj.score_space(1,2)).to eq([0,-1,0,1,1,1,1,1])
		end
		it "should produce correct scores when a win condition is met" do
			obj.reset
			obj.turn(1,:d)
			obj.turn(2,:e)
			obj.turn(1,:c)
			obj.turn(2,:b)
			obj.turn(1,:d)
			obj.turn(2,:b)
			obj.turn(1,:d)
			obj.turn(2,:d)
			obj.turn(1,:c)
			obj.turn(2,:c)
			obj.turn(1,:a)
			obj.turn(2,:e)
			obj.turn(1,:e)
			obj.turn(2,:f)
			obj.turn(1,:f)
			obj.turn(2,:f)
			obj.turn(1,:f)
			expect(obj.score_space(3,1)).to eq([2,1,1,0,2,1,4,3,0,-1])
			expect(obj.score_space(2,0)).to eq([1,2,0,0,4,nil])
			expect(obj.score_space(6,0)).to eq([0,-1,nil,1])
			expect(obj.score_space(3,3)).to eq([2,1,0,-1,-1,0,0,-2,-3,-2,0,1,1])
		end
	end
	
	context "game_over? method" do
	
		it "should end the game when 4 tiles of the same colour are in a row (horizontally)" do
			obj.reset
			obj.turn(1,:d)
			obj.turn(1,:e)
			obj.turn(1,:c)
			obj.turn(1,:f)
			expect(obj.game_over?).to be true
		end
		
		it "should end the game for vertical connect four" do
			obj.reset
			obj.turn(1,:e)
			obj.turn(2,:a)
			obj.turn(1,:e)
			obj.turn(2,:a)
			obj.turn(1,:a)
			obj.turn(2,:e)
			obj.turn(1,:a)
			obj.turn(2,:e)
			obj.turn(1,:a)
			obj.turn(2,:e)
			expect(obj.game_over?).to be false
			obj.turn(1,:a)
			expect(obj.game_over?).to be true
		end
		
		it "should end the game for diagonal (sw->ne) connect four" do
			obj.reset
			obj.turn(1,:d)
			obj.turn(2,:d)
			obj.turn(1,:d)
			obj.turn(2,:e)
			obj.turn(1,:e)
			obj.turn(2,:e)
			obj.turn(1,:e)
			obj.turn(2,:f)
			obj.turn(1,:f)
			obj.turn(2,:f)
			expect(obj.game_over?).to be false
			obj.turn(1,:e)
			obj.turn(2,:f)
			obj.turn(1,:f)
			obj.turn(2,:g)
			obj.turn(1,:g)
			obj.turn(2,:g)
			expect(obj.game_over?).to be false
			obj.turn(1,:g)
			obj.turn(2,:g)
			expect(obj.game_over?).to be true
		end
		
		it "should end the game for diagonal (nw->se) connect four" do
			obj.reset
			obj.turn(1,:d)
			obj.turn(2,:c)
			obj.turn(1,:c)
			obj.turn(2,:b)
			obj.turn(1,:b)
			obj.turn(2,:a)
			obj.turn(1,:b)
			obj.turn(2,:a)
			obj.turn(1,:d)
			expect(obj.game_over?).to be false
			obj.turn(2,:a)
			obj.turn(1,:a)
			expect(obj.game_over?).to be true
		end
		
		it "should end the game when the board is full (42 turns)" do
			obj.reset
			obj.turn(1,:a)
			expect(obj.game_over?).to be false
			obj.turn(2,:a)
			expect(obj.game_over?).to be false
			obj.turn(1,:a)
			expect(obj.game_over?).to be false
			obj.turn(2,:a)
			expect(obj.game_over?).to be false
			obj.turn(1,:a)
			expect(obj.game_over?).to be false
			obj.turn(2,:a)
			expect(obj.game_over?).to be false
			obj.turn(1,:b)
			expect(obj.game_over?).to be false
			obj.turn(2,:b)
			expect(obj.game_over?).to be false
			obj.turn(1,:b)
			expect(obj.game_over?).to be false
			obj.turn(2,:b)
			expect(obj.game_over?).to be false
			obj.turn(1,:b)
			expect(obj.game_over?).to be false
			obj.turn(2,:b)
			expect(obj.game_over?).to be false
			obj.turn(1,:c)
			expect(obj.game_over?).to be false
			obj.turn(2,:c)
			expect(obj.game_over?).to be false
			obj.turn(1,:c)
			expect(obj.game_over?).to be false
			obj.turn(2,:c)
			expect(obj.game_over?).to be false
			obj.turn(1,:c)
			expect(obj.game_over?).to be false
			obj.turn(2,:c)
			expect(obj.game_over?).to be false
			obj.turn(1,:e)
			expect(obj.game_over?).to be false
			obj.turn(2,:d)
			expect(obj.game_over?).to be false
			obj.turn(1,:d)
			expect(obj.game_over?).to be false
			obj.turn(2,:d)
			expect(obj.game_over?).to be false
			obj.turn(1,:d)
			expect(obj.game_over?).to be false
			obj.turn(2,:d)
			expect(obj.game_over?).to be false
			obj.turn(1,:d)
			expect(obj.game_over?).to be false
			obj.turn(2,:f)
			expect(obj.game_over?).to be false
			obj.turn(1,:e)
			expect(obj.game_over?).to be false
			obj.turn(2,:e)
			expect(obj.game_over?).to be false
			obj.turn(1,:e)
			expect(obj.game_over?).to be false
			obj.turn(2,:e)
			expect(obj.game_over?).to be false
			obj.turn(1,:e)
			expect(obj.game_over?).to be false
			obj.turn(2,:f)
			expect(obj.game_over?).to be false
			obj.turn(1,:f)
			expect(obj.game_over?).to be false
			obj.turn(2,:f)
			expect(obj.game_over?).to be false
			obj.turn(1,:f)
			expect(obj.game_over?).to be false
			obj.turn(2,:f)
			expect(obj.game_over?).to be false
			obj.turn(1,:g)
			expect(obj.game_over?).to be false
			obj.turn(2,:g)
			expect(obj.game_over?).to be false
			obj.turn(1,:g)
			expect(obj.game_over?).to be false
			obj.turn(2,:g)
			expect(obj.game_over?).to be false
			obj.turn(1,:g)
			expect(obj.game_over?).to be false
			expect(obj.game_over?).to be false
			obj.turn(2,:g)
			expect(obj.game_over?).to be true
		end
	end
	
end