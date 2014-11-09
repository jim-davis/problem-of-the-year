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
end

def permutations(list)
  if list.length == 1
    list
  else
    result = []
    list.each do |elt|
      permutations(list.except(elt)).each do |p|
        # FIXME: this is_a test smells like a kludge
        result << [elt] + (p.is_a?(Array) ? p : [p])
      end
    end
    result
  end
end
