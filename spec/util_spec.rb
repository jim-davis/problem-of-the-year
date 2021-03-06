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
        expect(arr.except(1)).to eql([0,2,4])
      end
    end
    describe "if the array has only one element" do
      it "returns empty array" do
        arr = ["a"]
        expect(arr.except("a")).to eql([])
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
      expected = [["a", "b"], ["ab"], ["b", "a"],  ["ba"]]
      expect(lexical_combinations(arr)).to eql(expected)
    end
  end
  describe "with list of 3" do
    it "returns as expected" do
      arr = ["a", "b", "c"]
      expected = [["abc"], ["acb"], ["bac"], ["bca"], ["cab"], ["cba"], 
                  ["a", "bc"], ["a", "cb"], ["ab", "c"], ["ac", "b"],
                  ["b", "ac"], ["b", "ca"], ["ba", "c"], ["bc", "a"],
                  ["c", "ab"], ["c", "ba"], ["ca", "b"], ["cb", "a"],
                  ["a", "b", "c"], ["a", "c", "b"],
                  ["b", "a", "c"], ["b", "c", "a"],
                  ["c", "a", "b"], ["c", "b", "a"]]
      result = lexical_combinations(arr)
      expect(result).to match_array(expected)
    end
  end
  
end

describe "#is_Integer?" do
  describe "Integer" do
    it "is always true" do
      expect(2.is_Integer?).to eq(true)
    end
  end

  describe "Float" do
    it "is true for round numbers" do
      expect((24.0).is_Integer?).to eq(true)
    end
    it "is false for not-round numbers" do
      expect((24.1).is_Integer?).to eq(false)
    end
  end

  describe "Rational" do
    it "is true for round numbers" do
      expect(Rational(2,2).is_Integer?).to eq(true)
    end
    it "is false for not-round numbers" do
      expect(Rational(2,3).is_Integer?).to eq(false)
    end
  end
  
end

describe "#asArray" do
  describe "given a scalar" do
    it "returns an array of that scalar" do
      r = asArray(nil)
      expect(r).to be_kind_of(Array)
      expect(r.count).to eq(1)
      expect(r[0]).to eq(nil)
    end
  end
  describe "given an array" do
    it "returns that array" do
      a = [259, 11]
      expect(asArray(a)).to eq(a)
    end
  end
end
