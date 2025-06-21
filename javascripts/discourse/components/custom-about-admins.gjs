import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import CustomAboutPageUsers from "./custom-about-page-users";
import { getOwner } from "@ember/application";
import { i18n } from "discourse-i18n";

export default class CustomAboutAdmins extends Component {
  @tracked detailedAdmins = [];
  @tracked isLoading = false;

  constructor() {
    super(...arguments);
    this.loadDetailedUserData();
  }

  willDestroy() {
    super.willDestroy();
    // Ensure we clean up any pending operations
    this.isLoading = false;
  }

  async loadDetailedUserData() {
    if (this.isLoading) {
      return;
    }

    const admins = this.args.outletArgs?.model?.admins || [];
    if (!admins.length) {
      return;
    }

    this.isLoading = true;
    
    try {
      const store = getOwner(this).lookup("service:store");
      
      const detailedAdminData = await Promise.all(
        admins.map(async (user) => {
          if (!this.isLoading) {
            // If component is being destroyed, abort
            return user;
          }
          try {
            const userRecord = await store.find('user', user.username);
            return userRecord;
          } catch (error) {
            console.error(`[AdminWrapper] Error fetching data for ${user.username}:`, error);
            return user;
          }
        })
      );

      if (this.isLoading) {
        this.detailedAdmins = detailedAdminData;
      }
    } catch (error) {
      console.error("[AdminWrapper] Error fetching detailed user data:", error);
      this.detailedAdmins = admins;
    } finally {
      this.isLoading = false;
    }
  }

  get admins() {
    return this.detailedAdmins.length > 0 ? 
      this.detailedAdmins : 
      (this.args.outletArgs?.model?.admins || []);
  }

  get truncateAt() {
    return 6;
  }

  <template>
    {{#if this.admins.length}}
      <section class="about__admins custom-about-section">
        <h3>{{i18n "about.our_admins"}}</h3>
        <CustomAboutPageUsers
          @users={{this.admins}}
          @truncateAt={{this.truncateAt}}
        />
      </section>
    {{/if}}
  </template>
} 