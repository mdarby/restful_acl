module RestfulAcl
  module Model

    def self.included(base)
      base.extend(ClassMethods)
      base.send :include, ClassMethods
    end

    module ClassMethods
      attr_accessor :mom, :singleton

      def logical_parent(model, *options)
        @mom = model
        @singleton = options.include?(:singleton)

        include InstanceMethods
      end

      def has_parent?
        @mom.present?
      end

      def is_singleton?
        @singleton.present?
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
end