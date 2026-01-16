import Component from "@ember/component";
import { hash } from "@ember/helper";
import { ajax } from "discourse/lib/ajax";
import BoxTag from "./box-tag";
import TagSelector from "./tag-selector";

function parseSetting(setting) {
  return setting.split("|").map((option) => option.trim());
}

export default class TagGroupFilter extends Component {
  dropdownGroups = [];
  boxGroups = [];

  async didInsertElement() {
    super.didInsertElement(...arguments);

    if (!this.category) {
      return;
    }

    if (!this.element || this.isDestroying || this.isDestroyed) {
      return;
    }

    let allowedTagGroups = this.category.allowed_tag_groups;

    if (allowedTagGroups.length) {
      // get box style tag groups from setting
      const boxStyleSetting = parseSetting(settings.filter_type_box);
      let boxGroups = [];
      let dropdownGroups = [];

      // get allowed tag groups + tags for the category
      const { results } = await ajax(`/tag_groups/filter/search`, {
        data: { names: allowedTagGroups },
      });

      // TODO(https://github.com/discourse/discourse/pull/36678): The string check can be
      // removed using .discourse-compatibility once the PR is merged.
      results.forEach((tagGroup) => {
        // Handle both old format (tag_names: string[]) and new format (tags: object[])
        const tagSource = tagGroup.tags || tagGroup.tag_names || [];
        const group = {
          name: tagGroup.name,
          tags: tagSource.map((t) =>
            typeof t === "string"
              ? { id: t, name: t }
              : { id: t.id, name: t.name }
          ),
        };

        // separate results into box/dropdown styles
        if (boxStyleSetting.includes(group.name)) {
          boxGroups.push(group);
        } else {
          dropdownGroups.push(group);
        }
      });

      this.set("boxGroups", boxGroups);
      this.set("dropdownGroups", dropdownGroups);
    } else {
      this.set("boxGroups", null);
      this.set("dropdownGroups", null);
    }
  }

  <template>
    {{#if this.boxGroups}}
      <div class="custom-box-groups">
        {{#each this.boxGroups as |group|}}
          <div class="custom-box-group">
            <h4>{{group.name}}</h4>

            <ul>
              <BoxTag
                @tag={{hash name="all"}}
                @activeTag={{this.tag}}
                @category={{this.category}}
              />

              {{#each group.tags as |tag|}}
                <BoxTag
                  @tag={{tag}}
                  @activeTag={{this.tag}}
                  @category={{this.category}}
                />
              {{/each}}
            </ul>
          </div>
        {{/each}}
      </div>
    {{/if}}

    {{#if this.dropdownGroups}}
      <div class="custom-dropdown-groups">
        {{#each this.dropdownGroups as |group|}}
          <div class="custom-dropdown-group">
            <h4>{{group.name}}</h4>

            <TagSelector
              @allowedTags={{group.tags}}
              @currentCategory={{this.category}}
              @tag={{this.tag}}
            />
          </div>
        {{/each}}
      </div>
    {{/if}}
  </template>
}
