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

