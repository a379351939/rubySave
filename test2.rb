class Number < Struct.new(:value)
end
class Add < Struct.new(:left, :right)
end
class Multiply < Struct.new(:left, :right)
end

class Number
   def to_s
     value.to_s
   end
   def inspect
     "«#{self}»"
   end
end

class Add
   def to_s
     "#{left} + #{right}"
   end
   def inspect
     "«#{self}»"
   end
end

class Multiply
   def to_s
     "#{left} * #{right}"
   end
   def inspect
     "«#{self}»"
   end
 end

def reducible?(expression)
  case expression
  when Number
    false
  when Add, Multiply
    true
  end
 end

class Number
 def reducible?
   false
 end
end

class Add
 def reducible?
   true
 end
end

class Multiply
 def reducible?
   true
  end
end

class Add
 def reduce
   if left.reducible?
     Add.new(left.reduce, right)
   elsif right.reducible?
     Add.new(left, right.reduce)
   else
     Number.new(left.value + right.value)
   end
 end
end

class Multiply
  def reduce
    if left.reducible?
      Multiply.new(left.reduce, right)
    elsif right.reducible?
      Multiply.new(left, right.reduce)
    else
      Number.new(left.value * right.value)
    end
  end
end

class Machine < Struct.new(:expression)
  def step
    self.expression = expression.reduce
  end

  def run
    while expression.reducible?
      puts expression
      step
    end
    puts expression
  end
end

class Boolean < Struct.new(:value)
 def to_s
   value.to_s
 end
 def inspect
   "«#{self}»"
 end
 def reducible?
   false
 end
end

class LessThan < Struct.new(:left, :right)
   def to_s
     "#{left} < #{right}"
   end
   def inspect
     "«#{self}»"
   end
   def reducible?
     true
   end
   def reduce
     if left.reducible?
       LessThan.new(left.reduce, right)
     elsif right.reducible?
       LessThan.new(left, right.reduce)
     else
       Boolean.new(left.value < right.value)
     end
   end
 end

class Variable < Struct.new(:name)
  def to_s
    name.to_s
  end
  def inspect
    "«#{self}»"
  end
  def reducible?
    true
  end
end

class Variable
 def reduce(environment)
   environment[name]
 end
end

class Add
 def reduce(environment)
   if left.reducible?
     Add.new(left.reduce(environment), right)
   elsif right.reducible?
     Add.new(left, right.reduce(environment))
   else
     Number.new(left.value + right.value)
   end
 end
end

class Multiply
 def reduce(environment)
   if left.reducible?
     Multiply.new(left.reduce(environment), right)
   elsif right.reducible?
     Multiply.new(left, right.reduce(environment))
   else
     Number.new(left.value * right.value)
   end
 end
end

class LessThan
 def reduce(environment)
   if left.reducible?
     LessThan.new(left.reduce(environment), right)
   elsif right.reducible?
     LessThan.new(left, right.reduce(environment))
   else
     Boolean.new(left.value < right.value)
   end
 end
end

Object.send(:remove_const, :Machine) #忘记原来的 Machine
class Machine < Struct.new(:expression, :environment)
  def step
    self.expression = expression.reduce(environment)
  end
  def run
    while expression.reducible?
      puts expression
      step
    end
    puts expression
  end
end
