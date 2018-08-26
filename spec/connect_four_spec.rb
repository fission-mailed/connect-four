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

=begin	
	it "score_space method should return array of up to 13 scores" do
		expect(obj.score_space(:d,3).size).to be <= 13
	end
	
	
	it "should end the game when 4 tiles of the same colour are in a row" do
		obj.turn(1,:d)
		obj.turn(1,:e)
		obj.turn(1,:c)
		obj.turn(1,:f)
		expect(obj.game_over?).to be true
	end
=end
end