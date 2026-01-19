import Component from "@ember/component";
import { classNames } from "@ember-decorators/component";
import TagGroupFilter from "../../components/tag-group-filter";

@classNames("tag-navigation-outlet", "custom-filter")
export default class CustomFilter extends Component {
  <template>
    {{! Only render if no category context - category-navigation outlet handles that case }}
    {{#unless this.category}}
      <TagGroupFilter @category={{this.category}} @tag={{this.tag}} />
    {{/unless}}
  </template>
}
