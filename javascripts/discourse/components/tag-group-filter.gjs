import Component from "@glimmer/component";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { bind } from "discourse/lib/decorators";
import Category from "discourse/models/category";
import { ALL_TAGS_ID } from "discourse/select-kit/components/tag-drop";
import DAsyncContent from "discourse/ui-kit/d-async-content";
import { i18n } from "discourse-i18n";
import BoxTag from "./box-tag";
import TagSelector from "./tag-selector";

function parseSetting(setting) {
  return setting.split("|").map((option) => option.trim());
}

export default class TagGroupFilter extends Component {
  @service site;

  get allTag() {
    return { id: ALL_TAGS_ID, name: i18n("tagging.all_tags") };
  }

  @bind
  async loadFilterGroups(categoryId, { signal }) {
    if (!categoryId) {
      return null;
    }

    try {
      let allowedTagGroups = this.args.category.allowed_tag_groups;

      if (!Array.isArray(allowedTagGroups)) {
        const result = await Category.reloadById(categoryId);
        const category = this.site.updateCategory(result.category);
        const reloaded = category?.allowed_tag_groups;
        allowedTagGroups = Array.isArray(reloaded) ? reloaded : [];
      }

      // Hydrating the store above invalidates this computation, so a
      // superseding call is already scheduled with the same data.
      if (signal.aborted || !allowedTagGroups.length) {
        return null;
      }

      const boxStyleSetting = parseSetting(settings.filter_type_box);
      const { results } = await ajax("/tag_groups/filter/search", {
        data: { names: allowedTagGroups },
      });

      const boxGroups = [];
      const dropdownGroups = [];

      results.forEach((tagGroup) => {
        // Backward compatibility for https://github.com/discourse/discourse/pull/36678
        // which changes API response from tag_names (string[]) to tags (object[])
        const tagSource = tagGroup.tags || tagGroup.tag_names || [];
        const group = {
          name: tagGroup.name,
          tags: tagSource.map((t) =>
            typeof t === "string"
              ? { id: t, name: t, slug: t }
              : { id: t.id, name: t.name, slug: t.slug }
          ),
        };

        if (boxStyleSetting.includes(group.name)) {
          boxGroups.push(group);
        } else {
          dropdownGroups.push(group);
        }
      });

      if (!boxGroups.length && !dropdownGroups.length) {
        return null;
      }

      return { boxGroups, dropdownGroups };
    } catch {
      return null;
    }
  }

  <template>
    <DAsyncContent
      @asyncData={{this.loadFilterGroups}}
      @context={{@category.id}}
    >
      <:loading></:loading>
      <:content as |groups|>
        {{#if groups.boxGroups}}
          <div class="custom-box-groups">
            {{#each groups.boxGroups as |group|}}
              <div class="custom-box-group">
                <h4>{{group.name}}</h4>

                <ul>
                  <BoxTag
                    @tag={{this.allTag}}
                    @activeTag={{@tag}}
                    @category={{@category}}
                  />

                  {{#each group.tags as |tag|}}
                    <BoxTag
                      @tag={{tag}}
                      @activeTag={{@tag}}
                      @category={{@category}}
                    />
                  {{/each}}
                </ul>
              </div>
            {{/each}}
          </div>
        {{/if}}

        {{#if groups.dropdownGroups}}
          <div class="custom-dropdown-groups">
            {{#each groups.dropdownGroups as |group|}}
              <div class="custom-dropdown-group">
                <h4>{{group.name}}</h4>

                <TagSelector
                  @allowedTags={{group.tags}}
                  @currentCategory={{@category}}
                  @tag={{@tag}}
                />
              </div>
            {{/each}}
          </div>
        {{/if}}
      </:content>
    </DAsyncContent>
  </template>
}
