This file is a merged representation of a subset of the codebase, containing specifically included files, combined into a single document by Repomix.
The content has been processed where security check has been disabled.

<file_summary>
This section contains a summary of this file.

<purpose>
This file contains a packed representation of the entire repository's contents.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.
</purpose>

<file_format>
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files, each consisting of:
  - File path as an attribute
  - Full contents of the file
</file_format>

<usage_guidelines>
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.
</usage_guidelines>

<notes>
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Only files matching these patterns are included: **/components/about*.gjs
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Security check has been disabled - content may contain sensitive information
- Files are sorted by Git change count (files with more changes are at the bottom)
</notes>

<additional_info>

</additional_info>

</file_summary>

<directory_structure>
app/
  assets/
    javascripts/
      discourse/
        app/
          components/
            about-page-user.gjs
            about-page-users.gjs
            about-page.gjs
        tests/
          integration/
            components/
              about-page-test.gjs
</directory_structure>

<files>
This section contains the contents of the repository's files.

<file path="app/assets/javascripts/discourse/app/components/about-page-user.gjs">
import avatar from "discourse/helpers/avatar";
import { prioritizeNameInUx } from "discourse/lib/settings";
import { userPath } from "discourse/lib/url";
import { i18n } from "discourse-i18n";

const AboutPageUser = <template>
  <div data-username={{@user.username}} class="user-info small">
    <div class="user-image">
      <div class="user-image-inner">
        <a
          href={{userPath @user.username}}
          data-user-card={{@user.username}}
          aria-hidden="true"
        >
          {{avatar @user imageSize="large"}}
        </a>
      </div>
    </div>
    <div class="user-detail">
      <div class="name-line">
        <a
          href={{userPath @user.username}}
          data-user-card={{@user.username}}
          aria-label={{i18n "user.profile_possessive" username=@user.username}}
        >
          <span class="username">
            {{#if (prioritizeNameInUx @user.name)}}
              {{@user.name}}
            {{else}}
              {{@user.username}}
            {{/if}}
          </span>
          <span class="name">
            {{#if (prioritizeNameInUx @user.name)}}
              {{@user.username}}
            {{else}}
              {{@user.name}}
            {{/if}}
          </span>
        </a>
      </div>
      <div class="title">{{@user.title}}</div>
    </div>
  </div>
</template>;

export default AboutPageUser;
</file>

<file path="app/assets/javascripts/discourse/app/components/about-page-users.gjs">
import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import AboutPageUser from "discourse/components/about-page-user";
import DButton from "discourse/components/d-button";
import { i18n } from "discourse-i18n";

export default class AboutPageUsers extends Component {
  @tracked expanded = false;

  get users() {
    let users = this.args.users;
    if (this.showViewMoreButton && !this.expanded) {
      users = users.slice(0, this.args.truncateAt);
    }
    return users;
  }

  get showViewMoreButton() {
    return (
      this.args.truncateAt > 0 && this.args.users.length > this.args.truncateAt
    );
  }

  @action
  toggleExpanded() {
    this.expanded = !this.expanded;
  }

  <template>
    <div class="about-page-users-list">
      {{#each this.users as |user|}}
        <AboutPageUser @user={{user}} />
      {{/each}}
    </div>
    {{#if this.showViewMoreButton}}
      <DButton
        class="btn-flat about-page-users-list__expand-button"
        @action={{this.toggleExpanded}}
        @icon={{if this.expanded "chevron-up" "chevron-down"}}
        @translatedLabel={{if
          this.expanded
          (i18n "about.view_less")
          (i18n "about.view_more")
        }}
      />
    {{/if}}
  </template>
}
</file>

<file path="app/assets/javascripts/discourse/app/components/about-page.gjs">
import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { LinkTo } from "@ember/routing";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import AboutPageUsers from "discourse/components/about-page-users";
import PluginOutlet from "discourse/components/plugin-outlet";
import icon from "discourse/helpers/d-icon";
import escape from "discourse/lib/escape";
import { number } from "discourse/lib/formatter";
import I18n, { i18n } from "discourse-i18n";

const pluginActivitiesFuncs = [];

export function addAboutPageActivity(name, func) {
  pluginActivitiesFuncs.push({ name, func });
}

export function clearAboutPageActivities() {
  pluginActivitiesFuncs.clear();
}

export default class AboutPage extends Component {
  @service siteSettings;
  @service currentUser;

  get moderatorsCount() {
    return this.args.model.moderators.length;
  }

  get adminsCount() {
    return this.args.model.admins.length;
  }

  get stats() {
    return [
      {
        class: "members",
        icon: "users",
        display: true,
        text: i18n("about.member_count", {
          count: this.args.model.stats.users_count,
          formatted_number: I18n.toNumber(this.args.model.stats.users_count, {
            precision: 0,
          }),
        }),
      },
      {
        class: "admins",
        icon: "shield-halved",
        display: this.adminsCount > 0,
        text: i18n("about.admin_count", {
          count: this.adminsCount,
          formatted_number: I18n.toNumber(this.adminsCount, { precision: 0 }),
        }),
      },
      {
        class: "moderators",
        icon: "shield-halved",
        display: this.moderatorsCount > 0,
        text: i18n("about.moderator_count", {
          count: this.moderatorsCount,
          formatted_number: I18n.toNumber(this.moderatorsCount, {
            precision: 0,
          }),
        }),
      },
      {
        class: "site-creation-date",
        icon: "calendar-days",
        display: true,
        text: this.siteAgeString,
      },
    ];
  }

  get siteActivities() {
    const list = [
      {
        icon: "scroll",
        class: "topics",
        activityText: i18n("about.activities.topics", {
          count: this.args.model.stats.topics_7_days,
          formatted_number: number(this.args.model.stats.topics_7_days),
        }),
        period: i18n("about.activities.periods.last_7_days"),
      },
      {
        icon: "pencil",
        class: "posts",
        activityText: i18n("about.activities.posts", {
          count: this.args.model.stats.posts_last_day,
          formatted_number: number(this.args.model.stats.posts_last_day),
        }),
        period: i18n("about.activities.periods.today"),
      },
      {
        icon: "user-group",
        class: "active-users",
        activityText: i18n("about.activities.active_users", {
          count: this.args.model.stats.active_users_7_days,
          formatted_number: number(this.args.model.stats.active_users_7_days),
        }),
        period: i18n("about.activities.periods.last_7_days"),
      },
      {
        icon: "user-plus",
        class: "sign-ups",
        activityText: i18n("about.activities.sign_ups", {
          count: this.args.model.stats.users_7_days,
          formatted_number: number(this.args.model.stats.users_7_days),
        }),
        period: i18n("about.activities.periods.last_7_days"),
      },
      {
        icon: "heart",
        class: "likes",
        activityText: i18n("about.activities.likes", {
          count: this.args.model.stats.likes_count,
          formatted_number: number(this.args.model.stats.likes_count),
        }),
        period: i18n("about.activities.periods.all_time"),
      },
    ];

    if (this.displayVisitorStats) {
      list.splice(2, 0, {
        icon: "user-secret",
        class: "visitors",
        activityText: I18n.messageFormat("about.activities.visitors_MF", {
          total_count: this.args.model.stats.visitors_7_days,
          eu_count: this.args.model.stats.eu_visitors_7_days,
          total_formatted_number: number(this.args.model.stats.visitors_7_days),
          eu_formatted_number: number(this.args.model.stats.eu_visitors_7_days),
        }),
        period: i18n("about.activities.periods.last_7_days"),
      });
    }

    return list.concat(this.siteActivitiesFromPlugins());
  }

  get displayVisitorStats() {
    return (
      this.siteSettings.display_eu_visitor_stats &&
      typeof this.args.model.stats.eu_visitors_7_days === "number" &&
      typeof this.args.model.stats.visitors_7_days === "number"
    );
  }

  get contactInfo() {
    const url = escape(this.args.model.contact_url || "");
    const email = escape(this.args.model.contact_email || "");

    if (url) {
      const href = this.contactURLHref;
      return i18n("about.contact_info", {
        contact_info: `<a href='${href}' target='_blank'>${url}</a>`,
      });
    } else if (email) {
      return i18n("about.contact_info", {
        contact_info: `<a href="mailto:${email}">${email}</a>`,
      });
    } else {
      return null;
    }
  }

  get contactURLHref() {
    const url = escape(this.args.model.contact_url || "");

    if (!url) {
      return;
    }

    if (url.startsWith("/") || url.match(/^\w+:/)) {
      return url;
    }

    return `//${url}`;
  }

  get siteAgeString() {
    const creationDate = new Date(this.args.model.site_creation_date);

    let diff = new Date() - creationDate;
    diff /= 1000 * 3600 * 24 * 30;

    if (diff < 1) {
      return i18n("about.site_age.less_than_one_month");
    } else if (diff < 12) {
      return i18n("about.site_age.month", { count: Math.round(diff) });
    } else {
      diff /= 12;
      return i18n("about.site_age.year", { count: Math.round(diff) });
    }
  }

  get trafficInfoFooter() {
    return I18n.messageFormat("about.traffic_info_footer_MF", {
      total_visitors: this.args.model.stats.visitors_30_days,
      eu_visitors: this.args.model.stats.eu_visitors_30_days,
    });
  }

  siteActivitiesFromPlugins() {
    const stats = this.args.model.stats;
    const statKeys = Object.keys(stats);

    const configs = [];
    for (const { name, func } of pluginActivitiesFuncs) {
      let present = false;
      const periods = {};
      for (const stat of statKeys) {
        const prefix = `${name}_`;
        if (stat.startsWith(prefix)) {
          present = true;
          const period = stat.replace(prefix, "");
          periods[period] = stats[stat];
        }
      }
      if (!present) {
        continue;
      }
      const config = func(periods);
      if (config) {
        configs.push(config);
      }
    }
    return configs;
  }

  <template>
    {{#if this.currentUser.admin}}
      <p>
        <LinkTo class="edit-about-page" @route="adminConfig.about">
          {{icon "pencil"}}
          <span>{{i18n "about.edit"}}</span>
        </LinkTo>
      </p>
    {{/if}}
    <section class="about__header">
      {{#if @model.banner_image}}
        <div class="about__banner">
          <img class="about__banner-img" src={{@model.banner_image}} />
        </div>
      {{/if}}
      <h3>{{@model.title}}</h3>
      <p class="short-description">{{@model.description}}</p>
      <PluginOutlet
        @name="about-after-description"
        @connectorTagName="section"
        @outletArgs={{hash model=@model}}
      />
    </section>
    <div class="about__main-content">
      <div class="about__left-side">
        <div class="about__stats">
          {{#each this.stats as |stat|}}
            {{#if stat.display}}
              <span class="about__stats-item {{stat.class}}">
                {{icon stat.icon}}
                <span>{{stat.text}}</span>
              </span>
            {{/if}}
          {{/each}}
        </div>

        {{#if @model.extended_site_description}}
          <h3>{{i18n "about.simple_title"}}</h3>
          <div>{{htmlSafe @model.extended_site_description}}</div>
        {{/if}}

        {{#if @model.admins.length}}
          <section class="about__admins">
            <h3>{{i18n "about.our_admins"}}</h3>
            <AboutPageUsers @users={{@model.admins}} @truncateAt={{6}} />
          </section>
        {{/if}}
        <PluginOutlet
          @name="about-after-admins"
          @connectorTagName="section"
          @outletArgs={{hash model=@model}}
        />

        {{#if @model.moderators.length}}
          <section class="about__moderators">
            <h3>{{i18n "about.our_moderators"}}</h3>
            <AboutPageUsers @users={{@model.moderators}} @truncateAt={{6}} />
          </section>
        {{/if}}
        <PluginOutlet
          @name="about-after-moderators"
          @connectorTagName="section"
          @outletArgs={{hash model=@model}}
        />
      </div>

      <div class="about__right-side">
        <h3>{{i18n "about.contact"}}</h3>
        {{#if this.contactInfo}}
          <p class="about__contact-info">{{htmlSafe this.contactInfo}}</p>
        {{/if}}
        <p>{{i18n "about.report_inappropriate_content"}}</p>
        <h3>{{i18n "about.site_activity"}}</h3>
        <div class="about__activities">
          {{#each this.siteActivities as |activity|}}
            <div class="about__activities-item {{activity.class}}">
              <span class="about__activities-item-icon">{{icon
                  activity.icon
                }}</span>
              <span class="about__activities-item-type">
                <div
                  class="about__activities-item-count"
                >{{activity.activityText}}</div>
                <div
                  class="about__activities-item-period"
                >{{activity.period}}</div>
              </span>
            </div>
          {{/each}}
        </div>
        {{#if this.displayVisitorStats}}
          <p class="about traffic-info-footer"><small
            >{{this.trafficInfoFooter}}</small></p>
        {{/if}}
      </div>
    </div>
  </template>
}
</file>

<file path="app/assets/javascripts/discourse/tests/integration/components/about-page-test.gjs">
import { render } from "@ember/test-helpers";
import { module, test } from "qunit";
import AboutPage from "discourse/components/about-page";
import { withPluginApi } from "discourse/lib/plugin-api";
import { setupRenderingTest } from "discourse/tests/helpers/component-test";
import I18n from "discourse-i18n";

function createModelObject({
  title = "My Forums",
  admins = [],
  moderators = [],
  stats = {},
}) {
  const model = arguments[0] || {};
  return Object.assign(
    {
      title,
      admins,
      moderators,
      stats,
    },
    model
  );
}

module("Integration | Component | about-page", function (hooks) {
  setupRenderingTest(hooks);

  test("custom site activities registered via the plugin API", async function (assert) {
    withPluginApi("1.37.0", (api) => {
      api.addAboutPageActivity("my_custom_activity", (periods) => {
        return {
          icon: "eye",
          class: "custom-activity",
          activityText: `${periods["3_weeks"]} my custom activity`,
          period: "in the last 3 weeks",
        };
      });

      api.addAboutPageActivity("another_custom_activity", () => null);
    });

    const model = createModelObject({
      stats: {
        my_custom_activity_3_weeks: 342,
        my_custom_activity_1_year: 123,
        another_custom_activity_1_day: 994,
      },
    });

    await render(<template><AboutPage @model={{model}} /></template>);
    assert
      .dom(".about__activities-item.custom-activity")
      .exists("my_custom_activity is rendered");
    assert
      .dom(".about__activities-item.custom-activity .d-icon-eye")
      .exists("icon for my_custom_activity is rendered");
    assert
      .dom(
        ".about__activities-item.custom-activity .about__activities-item-count"
      )
      .hasText("342 my custom activity");
    assert
      .dom(
        ".about__activities-item.custom-activity .about__activities-item-period"
      )
      .hasText("in the last 3 weeks");
  });

  test("visitor stats are not rendered if they're not available in the model", async function (assert) {
    this.siteSettings.display_eu_visitor_stats = true;
    let model = createModelObject({
      stats: {},
    });

    await render(<template><AboutPage @model={{model}} /></template>);
    assert
      .dom(".about__activities-item.visitors")
      .doesNotExist("visitors stats item is not rendered");

    model = createModelObject({
      stats: {
        eu_visitors_7_days: 13,
        eu_visitors_30_days: 30,
        visitors_7_days: 33,
        visitors_30_days: 103,
      },
    });

    await render(<template><AboutPage @model={{model}} /></template>);
    assert
      .dom(".about__activities-item.visitors")
      .exists("visitors stats item is rendered");
    assert
      .dom(".about__activities-item.visitors .about__activities-item-count")
      .hasText(
        I18n.messageFormat("about.activities.visitors_MF", {
          total_count: 33,
          eu_count: 13,
          total_formatted_number: "33",
          eu_formatted_number: "13",
        })
      );
  });

  test("contact URL", async function (assert) {
    let model = createModelObject({
      contact_url: "www.example.com",
    });

    await render(<template><AboutPage @model={{model}} /></template>);

    assert
      .dom(".about__contact-info a")
      .hasAttribute(
        "href",
        "//www.example.com",
        "appends a double slash if the value doesn't start with a slash or a protocol"
      );

    model.contact_url = "/u/somebody";

    await render(<template><AboutPage @model={{model}} /></template>);

    assert
      .dom(".about__contact-info a")
      .hasAttribute(
        "href",
        "/u/somebody",
        "doesn't append a double slash if the value starts with a slash"
      );

    model.contact_url = "https://example.com";

    await render(<template><AboutPage @model={{model}} /></template>);

    assert
      .dom(".about__contact-info a")
      .hasAttribute(
        "href",
        "https://example.com",
        "doesn't append a double slash if the value starts with a protocol"
      );
  });
});
</file>

</files>
