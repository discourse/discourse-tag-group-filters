import discourseComputed from "discourse/lib/decorators";
import TagDrop, { ALL_TAGS_ID } from "select-kit/components/tag-drop";

export default class TagSelector extends TagDrop {
  @discourseComputed("allowedTags")
  content(allowedTags) {
    return [{ id: ALL_TAGS_ID, name: this.allTagsLabel }].concat(allowedTags);
  }
}
