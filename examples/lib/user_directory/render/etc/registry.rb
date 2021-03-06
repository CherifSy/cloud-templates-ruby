require 'aws/templates/utils'

module UserDirectory
  module Render
    ##
    # UNIX passwd/group render
    #
    # Transforms formed catalog artifacts into standard UNIX passwd/group
    # representation.
    module Etc
      extend Aws::Templates::Render::Utils::BaseTypeViews
      initialize_base_type_views
      register ::Pathname, Aws::Templates::Render::Utils::BaseTypeViews::ToString
      Diff = Struct.new(:passwd, :group)

      ##
      # Diff view
      #
      # Creates Diff object out of the instance attached with recursively rendered passwd and group
      # fields.
      class DiffView < Aws::Templates::Render::BasicView
        register_in Render::Etc
        artifact Diff

        def to_rendered
          Diff.new rendered_for(instance.passwd), rendered_for(instance.group)
        end
      end
    end
  end
end
