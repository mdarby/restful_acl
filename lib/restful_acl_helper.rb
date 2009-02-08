module RestfulAclHelper
  def indexable
    return true if admin_enabled
    klass.is_indexable_by(current_user, parent_obj)
  end

  def creatable
    return true if admin_enabled
    klass.is_creatable_by(current_user, parent_obj)
  end
  alias_method :createable, :creatable


  def updatable(object)
    return true if admin_enabled

    parent = object.get_mom rescue nil
    object.is_updatable_by(current_user, parent)
  end
  alias_method :updateable, :updatable


  def deletable(object)
    return true if admin_enabled

    parent = object.get_mom rescue nil
    object.is_deletable_by(current_user, parent)
  end
  alias_method :deleteable, :deletable


  def readable(object)
    return true if admin_enabled

    parent = object.get_mom rescue nil
    object.is_readable_by(current_user, parent)
  end


  private

    def klass
      params[:controller].classify.constantize
    end

    def parent_obj
      parent_klass.find(parent_id) rescue nil
    end

    def parent_klass
      klass.mom.to_s.classify.constantize
    end

    def parent_id
      params["#{klass.mom.to_s}_id"]
    end

    def admin_enabled
      current_user.respond_to?("is_admin?") && current_user.is_admin?
    end

end
