# frozen_string_literal: true

require_relative "page_objects/components/tag_group_filter"

RSpec.describe "Tag group filters", type: :system do
  fab!(:tag) { Fabricate(:tag, name: "widgets") }
  fab!(:tag_group) { Fabricate(:tag_group, name: "Product", tags: [tag]) }
  fab!(:category) { Fabricate(:category, allowed_tag_groups: [tag_group.name]) }
  fab!(:user)

  let!(:theme) { upload_theme_component }
  let(:tag_group_filter) { PageObjects::Components::TagGroupFilter.new }

  before do
    SiteSetting.tagging_enabled = true
    sign_in(user)
  end

  it "filters by tag with dropdown style" do
    visit("/c/#{category.slug}/#{category.id}")

    expect(tag_group_filter).to have_dropdown_group_header("Product")

    dropdown = tag_group_filter.tag_dropdown
    dropdown.expand
    dropdown.select_row_by_name("widgets")

    expect(page).to have_current_path("/tags/c/#{category.slug}/#{category.id}/widgets")

    dropdown.expand
    dropdown.select_row_by_value("all-tags")

    expect(page).to have_current_path("/c/#{category.slug}/#{category.id}")
  end

  it "filters by tag with box style" do
    theme.update_setting(:filter_type_box, tag_group.name)
    theme.save!

    visit("/c/#{category.slug}/#{category.id}")

    expect(tag_group_filter).to have_box_group_header("Product")
    expect(tag_group_filter).to have_active_box_tag("All tags")

    tag_group_filter.click_box_tag("widgets")

    expect(page).to have_current_path("/tags/c/#{category.slug}/#{category.id}/widgets")
    expect(tag_group_filter).to have_active_box_tag("widgets")

    tag_group_filter.click_box_tag("All tags")

    expect(page).to have_current_path("/c/#{category.slug}/#{category.id}")
    expect(tag_group_filter).to have_active_box_tag("All tags")
  end
end
