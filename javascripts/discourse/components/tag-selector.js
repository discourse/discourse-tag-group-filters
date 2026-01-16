import discourseComputed from "discourse/lib/decorators";
import { i18n } from "discourse-i18n";
import TagDrop, { ALL_TAGS_ID } from "select-kit/components/tag-drop";

export default class TagSelector extends TagDrop {
  @discourseComputed("allowedTags")
  content(allowedTags) {
    const allOption = {
      id: ALL_TAGS_ID,
      name: i18n("tagging.all_tags"),
    };
    return [allOption, ...allowedTags];
  }
}
