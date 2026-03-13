import { computed } from "@ember/object";
import TagDrop, { ALL_TAGS_ID } from "discourse/select-kit/components/tag-drop";
import { i18n } from "discourse-i18n";

export default class TagSelector extends TagDrop {
  @computed("allowedTags")
  get content() {
    return [
      {
        id: ALL_TAGS_ID,
        name: i18n("tagging.all_tags"),
      },
      ...(this.allowedTags || []),
    ];
  }
}
