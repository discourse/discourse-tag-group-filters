import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";

export default Component.extend({
  tagName: "",

  @discourseComputed("tag", "activeTag")
  active(tag, activeTag) {
    return tag.id === activeTag?.id;
  },

  @discourseComputed("category", "tag", "activeTag")
  path(category, tag, activeTag) {
    if (tag.id) {
      if (this.tag && activeTag) {
        return `/tags/intersection/${activeTag.id}/${tag.id}`;
      } else {
        return `/tags/c/${category.slug}/${category.id}/${tag.id}`;
      }
    } else {
      return category.path;
    }
  },
});
