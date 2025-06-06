import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import discourseComputed from "discourse/lib/decorators";

@tagName("")
export default class BoxTag extends Component {
  @discourseComputed("tag", "activeTag")
  active(tag, activeTag) {
    return tag.id === activeTag?.id;
  }

  @discourseComputed("tag")
  dehyphenedTag(tag) {
    return tag.name.replace(/-/g, " ");
  }

  @discourseComputed("category", "tag")
  path(category, tag) {
    if (tag.id) {
      return `/tags/c/${category.slug}/${category.id}/${tag.id}`;
    } else {
      return category.path;
    }
  }

  <template>
    <li class={{if this.active "active"}}>
      <a href={{this.path}}>
        {{this.dehyphenedTag}}
      </a>
    </li>
  </template>
}
