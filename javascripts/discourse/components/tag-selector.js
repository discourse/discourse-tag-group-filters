import TagDrop, { ALL_TAGS_ID } from "select-kit/components/tag-drop";
import discourseComputed from "discourse-common/utils/decorators";
import DiscourseURL, { getCategoryAndTagUrl } from "discourse/lib/url";

export default TagDrop.extend({
  @discourseComputed("allowedTags")
  content(allowedTags) {
    return [{ id: ALL_TAGS_ID, name: this.allTagsLabel }].concat(allowedTags);
  },

  @discourseComputed("allowedTags", "tag")
  tagId(allowedTags, tag) {
    if (tag) {
      if (this.allowedTags.some((tag) => tag.id === this.tag.id)) {
        return this.tag.id;
      } else {
        return;
      }
    }
  },

  actions: {
    onChange(tagId, tag) {
      if (tagId === "NO_TAG_ID") {
        tagId = NONE_TAG_ID;
      } else if (tagId === ALL_TAGS_ID) {
        tagId = null;
      } else if (tag && tag.targetTagId) {
        tagId = tag.targetTagId;
      }

      let hasMatch;
      if (this.tag) {
        hasMatch = this.allowedTags.some((tag) => tag.id === this.tag.id);
      }

      if (
        this.tag && // if on a tag page
        !hasMatch && // if page's current tag is not in the menu's allowed list
        this.tag.id != "none" &&
        tag.id != "all-tags"
      ) {
        DiscourseURL.routeToUrl(`/tags/intersection/${this.tag.id}/${tagId}`);
      } else {
        DiscourseURL.routeToUrl(
          getCategoryAndTagUrl(
            this.currentCategory,
            !this.noSubcategories,
            tagId
          )
        );
      }
    },
  },
});
