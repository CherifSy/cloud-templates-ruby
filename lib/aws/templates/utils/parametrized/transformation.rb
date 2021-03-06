require 'aws/templates/utils'

module Aws
  module Templates
    module Utils
      module Parametrized
        ##
        # Transformation functor class
        #
        # A transformation is a Proc accepting input value and providing output
        # value which is expected to be a transformation of the input.
        # The proc is executed in instance context so instance methods can
        # be used for calculation.
        #
        # The class implements functor pattern through to_proc method and
        # closure. Essentially, all transformations can be used everywhere where
        # a block is expected.
        #
        # It provides protected method transform which should be overriden in
        # all concrete transformation classes.
        class Transformation
          ##
          # Creates closure with transformation invocation
          #
          # It's an interface method required for Transformation to expose
          # functor properties. It encloses invocation of Transformation
          # transform_wrapper method into a closure. The closure itself is
          # executed in the context of Parametrized instance which provides
          # proper set "self" variable.
          #
          # The closure itself accepts 2 parameters:
          # * +parameter+ - the Parameter object which the transformation
          #                 will be performed for
          # * +value+ - parameter value to be transformed
          # ...where instance is assumed from self
          def to_proc
            transform = self

            lambda do |parameter, value|
              transform.transform_wrapper(parameter, value, self)
            end
          end

          ##
          # Wraps transformation-dependent method
          #
          # It wraps constraint-dependent "transform" method into a rescue block
          # to standardize exception type and information provided by failed
          # transformation calculation
          # * +parameter+ - the Parameter object which the transformation will
          #                 be performed for
          # * +value+ - parameter value to be transformed
          # * +instance+ - the instance value is transform
          def transform_wrapper(parameter, value, instance)
            transform(parameter, value, instance)
          rescue StandardError
            raise Templates::Exception::NestedParameterException.new(parameter)
          end

          protected

          ##
          # Transform method
          #
          # * +parameter+ - the Parameter object which the transformation is
          #                 performed for
          # * +value+ - parameter value to be transformed
          # * +instance+ - the instance value is transform
          def transform(parameter, value, instance); end
        end
      end
    end
  end
end
