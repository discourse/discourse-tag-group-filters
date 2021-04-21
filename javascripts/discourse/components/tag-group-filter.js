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

  didInsertElement() {
    this._super(...arguments);

    // get box style tag groups from setting
    let boxStyleSetting = parseSetting(settings.filter_type_box);
    let boxGroups = [];
    let dropdownGroups = [];

    if (this.category.allowed_tag_groups.length) {
      // get allowed tag groups + tags for the category
      return ajax(`/tag_groups/filter/search`, {
        data: { names: this.category.allowed_tag_groups },
      }).then(({ results }) => {
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
      });
    } else {
      this.set("boxGroups", null);
      this.set("dropdownGroups", null);
    }
  },
});
