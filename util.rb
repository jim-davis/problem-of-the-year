class Array
  def except(elt)
    self - [elt]
  end
  def butfirst
    self[1..self.length]
  end
  def add(l)
    self << l
  end
  def remove_at(i)
    (i > 0 ? self[0..i-1] : []) + self[i+1..self.length]
  end
end

# Given a set of strings, 
# return the set of all sets 
# that can be formed by combining those strings in any order
# e.g. for three elements ["1", "2", "3"]
# ["1", "2", "3"] (and all permutations)
# plus six ["1", "23"], ["1", "32"], ["2", "13"], etc
# plus six more ["123"], ["132"]  etc
def lexical_combinations(strings)
  l = []
  if strings.length == 1
    l.add(strings)
  else
    strings.each do |letter|
      others = strings.except(letter)
      lexical_combinations(others).each do |subcombo|
        l.add([letter] + subcombo)
        l.add([letter + subcombo.first] + subcombo.butfirst)
      end
    end
  end
  l
end
