import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import CustomAboutPageUsers from "./custom-about-page-users";
import { getOwner } from "@ember/application";
import { modifier } from 'ember-modifier';

export default class CustomAboutModerators extends Component {
  @tracked detailedModerators = [];
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

    const moderators = this.args.outletArgs?.model?.moderators || [];
    if (!moderators.length) {
      return;
    }

    this.isLoading = true;
    
    try {
      const store = getOwner(this).lookup("service:store");
      console.log("[ModWrapper] Using store service to fetch user data");
      
      const detailedModData = await Promise.all(
        moderators.map(async (user) => {
          if (!this.isLoading) {
            // If component is being destroyed, abort
            return user;
          }
          console.log(`[ModWrapper] Fetching detailed data for moderator: ${user.username}`);
          try {
            const userRecord = await store.find('user', user.username);
            console.log(`[ModWrapper] Received moderator record for ${user.username}:`, userRecord);
            return userRecord;
          } catch (error) {
            console.error(`[ModWrapper] Error fetching data for ${user.username}:`, error);
            return user;
          }
        })
      );

      if (this.isLoading) {
        this.detailedModerators = detailedModData;
      }
    } catch (error) {
      console.error("[ModWrapper] Error fetching detailed user data:", error);
      this.detailedModerators = moderators;
    } finally {
      this.isLoading = false;
    }
  }

  get moderators() {
    return this.detailedModerators.length > 0 ? 
      this.detailedModerators : 
      (this.args.outletArgs?.model?.moderators || []);
  }

  get truncateAt() {
    return 6;
  }

  <template>
    {{#if this.moderators.length}}
      <div class="about-page-section moderators-section">
        <h3>Moderators</h3>
        <CustomAboutPageUsers
          @users={{this.moderators}}
          @truncateAt={{this.truncateAt}}
        />
      </div>
    {{/if}}
  </template>
} 