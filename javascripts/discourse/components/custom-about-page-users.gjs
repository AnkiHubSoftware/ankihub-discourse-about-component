import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import CustomAboutPageUser from "./custom-about-page-user";
import DButton from "discourse/components/d-button";
import { i18n } from "discourse-i18n";

export default class CustomAboutPageUsers extends Component {
  @tracked expanded = false;

  constructor() {
    super(...arguments);
    console.log("[CustomAboutPageUsers] Component initialized");
    console.log("[CustomAboutPageUsers] Initial args:", {
      users: this.args.users,
      truncateAt: this.args.truncateAt
    });
  }

  get users() {
    let users = this.args.users || [];
    console.log("[CustomAboutPageUsers] Raw users array:", users);
    
    if (this.showViewMoreButton && !this.expanded) {
      users = users.slice(0, this.args.truncateAt);
      console.log("[CustomAboutPageUsers] Truncated users array:", users);
    }
    
    console.log("[CustomAboutPageUsers] Final users array:", {
      length: users.length,
      expanded: this.expanded,
      showViewMore: this.showViewMoreButton
    });
    
    return users;
  }

  get showViewMoreButton() {
    const should = this.args.truncateAt > 0 && (this.args.users || []).length > this.args.truncateAt;
    console.log("[CustomAboutPageUsers] Show view more button:", {
      truncateAt: this.args.truncateAt,
      totalUsers: (this.args.users || []).length,
      shouldShow: should
    });
    return should;
  }

  @action
  toggleExpanded() {
    this.expanded = !this.expanded;
    console.log("[CustomAboutPageUsers] Toggled expanded state:", this.expanded);
  }

  <template>
    <div class="custom-about-page-users-list">
      {{#each this.users as |user|}}
        <CustomAboutPageUser @user={{user}} />
      {{/each}}
    </div>
    {{#if this.showViewMoreButton}}
      <DButton
        class="btn-flat custom-about-page-users-list__expand-button"
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