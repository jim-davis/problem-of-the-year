class Array
  def except(elt)
    self - [elt]
  end
end

def permutations(list)
  if list.length == 1
    list
  else
    result = []
    list.each do |elt|
      permutations(list.except(elt)).each do |p|
        result << [elt] + (p.is_a?(Array) ? p : [p])
      end
    end
    result
  end
end
