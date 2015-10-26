require "Rspec"
require "util"

describe Array do
  describe "except" do
    describe "if the element is not present" do
      it "returns array unmodified" do
        arr = []
        arr.except(nil)
        expect(arr.length).to eq(0)
      end
    end
    describe "if the element is present" do
      it "returns array without the element" do
        arr = [0,1,2,4] 
      end
    end
  end
  describe "butfirst" do
    it "returns all but the first element" do
      arr = [0,1,2,3]
      expect(arr.butfirst.length).to eq(3)
    end
  end
end

describe "lexical_combinations" do
  describe "with empty list" do
    it "returns an empty list" do
      expect(lexical_combinations([])).to eql([])
    end
  end
  describe "with list of 1" do
    it "returns the same list" do
      arr = ["x"]
      expected = [["x"]]
      expect(lexical_combinations(arr)).to eql(expected)
    end
  end
  describe "with list of 2" do
    it "returns two results" do
      arr = ["a", "b"]
      expected = [["a", "b"], ["ab"]]
      expect(lexical_combinations(arr)).to eql(expected)
    end
  end
  describe "with list of 3" do
    it "returns as expected" do
      arr = ["a", "b", "c"]
      expected = [["abc"], ["a", "bc"], ["ab", "c"], ["ac", "b"], ["a", "b", "c"]]
      result = lexical_combinations(arr).map{|x| x.sort}.sort{|a,b| a.length == b.length ? a[0] <=> b[0] : a.length <=> b.length}
      expect(result).to eql(expected)
    end
  end
  
end

