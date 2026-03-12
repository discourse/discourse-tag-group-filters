/* eslint-disable ember/no-classic-components */
import Component from "@ember/component";
import { computed } from "@ember/object";
import { tagName } from "@ember-decorators/component";
import { ALL_TAGS_ID } from "discourse/select-kit/components/tag-drop";

@tagName("")
export default class BoxTag extends Component {
  @computed("tag", "activeTag")
  get active() {
    if (this.tag.id === ALL_TAGS_ID) {
      return !this.activeTag?.name;
    }
    return this.tag.name === this.activeTag?.name;
  }

  @computed("tag")
  get dehyphenedTag() {
    return this.tag.name.replace(/-/g, " ");
  }

  @computed("category", "tag")
  get path() {
    if (this.tag.id !== ALL_TAGS_ID) {
      if (this.tag.name !== this.tag.id) {
        return `/tags/c/${this.category.slug}/${this.category.id}/${this.tag.slug}/${this.tag.id}`;
      } else {
        return `/tags/c/${this.category.slug}/${this.category.id}/${this.tag.name}`;
      }
    } else {
      return this.category.path;
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
