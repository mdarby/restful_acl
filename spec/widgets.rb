class ParentWidget
end

class Widget
  include RestfulAclModel
  logical_parent :parent_widget  
end

class SingletonWidget
  include RestfulAclModel
  logical_parent :parent_widget
end