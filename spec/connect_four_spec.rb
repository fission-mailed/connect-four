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
end