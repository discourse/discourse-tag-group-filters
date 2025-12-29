import { render } from "@ember/test-helpers";
import { setupRenderingTest } from "ember-qunit";
import { module, test } from "qunit";
import BoxTag from "../../discourse/components/box-tag";

module("Integration | Component | box-tag", function (hooks) {
  setupRenderingTest(hooks);

  test("generates path using tag name", async function (assert) {
    const self = this;

    this.set("tag", { id: 1, name: "my-tag" });
    this.set("activeTag", null);
    this.set("category", { id: 5, slug: "general", path: "/c/general/5" });

    await render(
      <template>
        <BoxTag
          @tag={{self.tag}}
          @activeTag={{self.activeTag}}
          @category={{self.category}}
        />
      </template>
    );

    assert
      .dom("a")
      .hasAttribute(
        "href",
        "/tags/c/general/5/my-tag",
        "link uses tag name in URL path"
      );
  });

  test("marks tag as active when names match", async function (assert) {
    const self = this;

    this.set("tag", { id: 1, name: "my-tag" });
    this.set("activeTag", { id: 99, name: "my-tag" });
    this.set("category", { id: 5, slug: "general", path: "/c/general/5" });

    await render(
      <template>
        <BoxTag
          @tag={{self.tag}}
          @activeTag={{self.activeTag}}
          @category={{self.category}}
        />
      </template>
    );

    assert
      .dom("li")
      .hasClass("active", "tag is marked as active by name match");
  });

  test("does not mark tag as active when only ids match", async function (assert) {
    const self = this;

    this.set("tag", { id: 1, name: "my-tag" });
    this.set("activeTag", { id: 1, name: "different-tag" });
    this.set("category", { id: 5, slug: "general", path: "/c/general/5" });

    await render(
      <template>
        <BoxTag
          @tag={{self.tag}}
          @activeTag={{self.activeTag}}
          @category={{self.category}}
        />
      </template>
    );

    assert
      .dom("li")
      .doesNotHaveClass("active", "tag is not active when only id matches");
  });
});
