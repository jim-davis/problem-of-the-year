require "Rspec"
require "util"

describe Array do
  describe "except" do
    describe "if the element is not present" do
      it "returns array unmodified" do
        arr = Array.new
        arr.except(nil)
        expect(arr.length).to eq(0)
      end
    end
  end
end

describe "lexical_combinations" do
  describe "with empty list" do
    it "returns an empty list" do
      expect(lexical_combinations([])).to eql([])
    end
  end
  
end
