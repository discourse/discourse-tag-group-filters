import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";
import { ajax } from "discourse/lib/ajax";
import { inject as service } from "@ember/service";

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

      results.forEach((object) => {
        // separate results into box/dropdown styles
        if (boxStyleSetting.includes(object["name"])) {
          boxGroups.push(object);
        } else {
          dropdownGroups.push(object);
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
