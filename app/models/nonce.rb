# creates and manipulates random strings that can be used as seeds or keys
module Nonce
  @@CHARS = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['+', '/', '=']
  
  # generates a random string
  def generate(len = 5)
    @str = ''
    
    len.times do
      i = rand(@@CHARS.size)
      @str += @@CHARS[i]
    end
    
    @str
  end
  
  # randomly changes a character within the string
  def change_one(target)
    # change a random character to the next
    i = rand(target.size)
    
    # now randomly choose it to something else
    newc = new_char
    until newc != target[i]
      newc = new_char
    end
    
    target[i] = newc
    
    target
  end
  
  # adds a random character to the end of the given string
  def add_one(input)
    newc = new_char
    input + newc
  end
  
  # changes the string in some way
  # in: How often to add a character rather than changing one
  def increment(input, add_frequency = 10000)
    if rand(add_frequency) == 5
      add_one input
    else
      change_one input
    end
  end
  
  private
  
  def new_char
    @@CHARS[rand(@@CHARS.size)]
  end
end