class String
  
  def singular?
    other = self.dup
    other.pluralize != self
  end
  
end