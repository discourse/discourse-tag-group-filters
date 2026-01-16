# frozen_string_literal: true

module PageObjects
  module Components
    class TagGroupFilter < PageObjects::Components::Base
      def has_dropdown_groups?
        has_css?(".custom-dropdown-groups")
      end

      def has_no_dropdown_groups?
        has_no_css?(".custom-dropdown-groups")
      end

      def has_box_groups?
        has_css?(".custom-box-groups")
      end

      def has_no_box_groups?
        has_no_css?(".custom-box-groups")
      end

      def has_dropdown_group_header?(name)
        has_css?(".custom-dropdown-group h4", text: name)
      end

      def has_box_group_header?(name)
        has_css?(".custom-box-group h4", text: name)
      end

      def has_tag_drop?
        has_css?(".tag-drop")
      end

      def has_box_tag?(name)
        has_css?(".custom-box-group li a", text: name)
      end

      def click_box_tag(name)
        find(".custom-box-group li a", text: name).click
      end
    end
  end
end
