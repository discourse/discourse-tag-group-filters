import Component from "@ember/component";
import { classNames } from "@ember-decorators/component";
import TagGroupFilter from "../../components/tag-group-filter";

@classNames("category-navigation-outlet", "custom-filter")
export default class CustomFilter extends Component {
  <template>
    <TagGroupFilter @category={{this.category}} @tag={{this.tag}} />
  </template>
}
