import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import discourseComputed from "discourse/lib/decorators";
import { ALL_TAGS_ID } from "select-kit/components/tag-drop";

@tagName("")
export default class BoxTag extends Component {
  @discourseComputed("tag", "activeTag")
  active(tag, activeTag) {
    if (tag.id === ALL_TAGS_ID) {
      return !activeTag?.name;
    }
    return tag.name === activeTag?.name;
  }

  @discourseComputed("tag")
  dehyphenedTag(tag) {
    return tag.name.replace(/-/g, " ");
  }

  @discourseComputed("category", "tag")
  path(category, tag) {
    if (tag.id !== ALL_TAGS_ID) {
      if (tag.name !== tag.id) {
        return `/tags/c/${category.slug}/${category.id}/${tag.slug}/${tag.id}`;
      } else {
        return `/tags/c/${category.slug}/${category.id}/${tag.name}`;
      }
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
