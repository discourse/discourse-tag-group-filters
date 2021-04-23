import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";

export default Component.extend({
  tagName: "",

  @discourseComputed("tag", "activeTag")
  active(tag, activeTag) {
    return tag.id === activeTag?.id;
  },

  @discourseComputed("category", "tag")
  path(category, tag) {
    if (tag.id) {
      return `/tags/c/${category.slug}/${category.id}/${tag.id}`;
    } else {
      return category.path;
    }
  },
});
