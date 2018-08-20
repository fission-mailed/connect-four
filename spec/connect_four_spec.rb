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
end