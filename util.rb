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

# Given a list of strings, e.g. ["1", "2", "3"]
# return all the ways these can be combined as strings
# e.g. [["1", "2", "3"] (no combination), ["1", "23"], ["12", "3"], ["123"]]
def lexical_combinations(strings)
  l = []
  if strings.length > 0
    if strings.length == 1
      l.add(strings)
    else
      digit = strings.first
      lexical_combinations(strings.butfirst).each do |tail|
        l.add([digit] + tail)     # keep separate or
        l.add([digit + tail.first] + tail.butfirst) # combine first and second
      end
    end
  end
  l
end


