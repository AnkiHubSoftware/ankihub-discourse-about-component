import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import CustomAboutPageUsers from "./custom-about-page-users";
import { getOwner } from "@ember/application";
import { modifier } from 'ember-modifier';

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
      console.log("[AdminWrapper] Using store service to fetch user data");
      
      const detailedAdminData = await Promise.all(
        admins.map(async (user) => {
          if (!this.isLoading) {
            // If component is being destroyed, abort
            return user;
          }
          console.log(`[AdminWrapper] Fetching detailed data for admin: ${user.username}`);
          try {
            const userRecord = await store.find('user', user.username);
            console.log(`[AdminWrapper] Detailed admin data for ${user.username}:`, {
              username: userRecord.username,
              title: userRecord.title,
              name: userRecord.name,
              bio: userRecord.bio_excerpt
            });
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
      <div class="about-page-section admins-section">
        <h3>Administrators</h3>
        <CustomAboutPageUsers
          @users={{this.admins}}
          @truncateAt={{this.truncateAt}}
        />
      </div>
    {{/if}}
  </template>
} 