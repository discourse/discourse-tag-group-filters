import Component from "@ember/component";
import { ajax } from "discourse/lib/ajax";
import { schedule } from "@ember/runloop";

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

      schedule("afterRender", () => {
        if (!this.element || this.isDestroying || this.isDestroyed) {
          return;
        }
        if (this.boxGroups) {
          // set active box state
          if (this.tag) {
            document
              .getElementById("box-" + this.tag.id)
              .classList.add("active");
          } else {
            document.getElementById("box-all").classList.add("active");
          }
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
