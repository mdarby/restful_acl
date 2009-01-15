class <%= class_name %> < ActiveRecord::Base
  <% if parent_class %>
  my_mom :<%= parent_class %>
  <% end %>
  
  def self.is_indexable_by(user, parent = nil)

  end
  
  def self.is_creatable_by(user, parent = nil)

  end
  
  def is_updatable_by(user, parent = nil)

  end

  def is_deletable_by(user, parent = nil)

  end

  def is_readable_by(user, parent = nil)

  end

end