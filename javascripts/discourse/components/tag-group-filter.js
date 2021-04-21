import Component from "@ember/component";
import { ajax } from "discourse/lib/ajax";

function parseSetting(setting) {
  return setting.split("|").map((option) => option.trim());
}

export default Component.extend({
  dropdownGroups: [],
  boxGroups: [],

  async didInsertElement() {
    this._super(...arguments);

    const allowedTagGroups = this.category.allowed_tag_groups;

    if (allowedTagGroups.length) {
      // get box style tag groups from setting
      const boxStyleSetting = parseSetting(settings.filter_type_box);
      let boxGroups = [];
      let dropdownGroups = [];

      // get allowed tag groups + tags for the category
      const { results } = await ajax(`/tag_groups/filter/search`, {
        data: { names: allowedTagGroups },
      });

      results.forEach((tagGroup) => {
        const group = {
          name: tagGroup.name,
          tags: tagGroup.tag_names.map((name) => ({
            id: name,
            name,
          })),
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
  },
});
