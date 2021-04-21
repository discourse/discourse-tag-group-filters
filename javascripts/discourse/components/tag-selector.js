import TagDrop, { ALL_TAGS_ID } from "select-kit/components/tag-drop";
import { computed } from "@ember/object";

export default TagDrop.extend({
  content: computed("allowedTags", function () {
    return [{ id: ALL_TAGS_ID, name: this.allTagsLabel }].concat(
      this.allowedTags
    );
  }),
});
