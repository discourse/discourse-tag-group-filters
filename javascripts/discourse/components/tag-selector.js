import TagDrop, { ALL_TAGS_ID } from "select-kit/components/tag-drop";
import { computed } from "@ember/object";
import discourseComputed from "discourse-common/utils/decorators";

export default TagDrop.extend({
  content: computed("allowedTags", function () {
    return [{ id: ALL_TAGS_ID, name: this.allTagsLabel }].concat(
      this.allowedTags
    );
  }),

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
});
