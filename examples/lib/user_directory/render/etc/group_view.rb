require 'aws/templates/utils'

module UserDirectory
  module Render
    module Etc
      ##
      # POSIX group render
      #
      # Creates group file entry.
      class GroupView < ArtifactView
        artifact UserDirectory::Artifacts::Group

        def prepare
          Render::Etc::Diff.new [], [group_record.join(':')]
        end

        def group_record
          in_instance { [name, 'x', id, members.map(&:login).join(',')] }
        end
      end
    end
  end
end
