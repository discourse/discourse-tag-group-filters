import TagDrop, { ALL_TAGS_ID } from "select-kit/components/tag-drop";
import discourseComputed from "discourse-common/utils/decorators";

export default TagDrop.extend({
  @discourseComputed("allowedTags")
  content(allowedTags) {
    return [{ id: ALL_TAGS_ID, name: this.allTagsLabel }].concat(allowedTags);
  },

  @discourseComputed("allowedTags", "tag")
  tagId(allowedTags, tag) {
    if (tag) {
      if (
        this.allowedTags.some((allowedTag) => allowedTag.id === this.tag.id)
      ) {
        return this.tag.id;
      } else {
        return;
      }
    }
  },
});
