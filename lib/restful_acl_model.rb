module RestfulAclModel

  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, ClassMethods
  end

  module ClassMethods
    attr_accessor :mom

    def logical_parent(model)
      self.mom = model
      include RestfulAclModel::InstanceMethods
    end

    def has_parent?
      !self.mom.nil?
    end

  end


  module InstanceMethods

    def get_mom
      parent_klass.find(parent_id) if has_parent?
    end

    private

      def klass
        self.class
      end

      def mom
        klass.mom
      end

      def has_parent?
        !mom.nil?
      end

      def parent_klass
        mom.to_s.classify.constantize
      end

      def parent_id
        self.instance_eval("#{mom}_id")
      end
  end

end
