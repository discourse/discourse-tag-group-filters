# frozen_string_literal: true

require_relative "page_objects/components/tag_group_filter"

RSpec.describe "Tag group filters", type: :system do
  fab!(:tag) { Fabricate(:tag, name: "widgets") }
  fab!(:tag_group) { Fabricate(:tag_group, name: "Product", tags: [tag]) }
  fab!(:category) { Fabricate(:category, allowed_tag_groups: [tag_group.name]) }
  fab!(:topic) { Fabricate(:topic, category:, tags: [tag]) }
  fab!(:post) { Fabricate(:post, topic:) }
  fab!(:user)

  let!(:theme) { upload_theme_component }
  let(:tag_group_filter) { PageObjects::Components::TagGroupFilter.new }

  before do
    SiteSetting.tagging_enabled = true
    sign_in(user)
  end

  context "with dropdown style (default)" do
    it "displays dropdown selector for tag group" do
      visit("/c/#{category.slug}/#{category.id}")

      expect(tag_group_filter).to have_dropdown_groups
      expect(tag_group_filter).to have_dropdown_group_header("Product")
      expect(tag_group_filter).to have_tag_drop
    end
  end

  context "with box style" do
    before do
      theme.update_setting(:filter_type_box, tag_group.name)
      theme.save!
    end

    it "displays box selector for tag group" do
      visit("/c/#{category.slug}/#{category.id}")

      expect(tag_group_filter).to have_box_groups
      expect(tag_group_filter).to have_box_group_header("Product")
      expect(tag_group_filter).to have_box_tag("all")
      expect(tag_group_filter).to have_box_tag("widgets")
    end

    it "navigates to tag-filtered page when clicking a tag" do
      visit("/c/#{category.slug}/#{category.id}")

      tag_group_filter.click_box_tag("widgets")

      expect(page).to have_current_path("/tags/c/#{category.slug}/#{category.id}/widgets")
    end
  end
end
