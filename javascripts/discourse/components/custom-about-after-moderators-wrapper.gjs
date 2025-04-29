import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import CustomAboutPageUsers from "./custom-about-page-users";
import { getOwner } from "@ember/application";

export default class CustomAboutAfterModeratorsWrapper extends Component {
  @tracked detailedUsers = [];

  constructor() {
    super(...arguments);
    this.loadDetailedUserData();
  }

  async loadDetailedUserData() {
    const moderators = this.args.outletArgs?.model?.moderators || [];
    console.log("[Wrapper] Initial moderators:", moderators);
    
    try {
      const store = getOwner(this).lookup("service:store");
      console.log("[Wrapper] Using store service to fetch user data");
      
      const detailedData = await Promise.all(
        moderators.map(async (user) => {
          console.log(`[Wrapper] Fetching detailed data for user: ${user.username}`);
          // Using store.find to get the user record with all attributes
          const userRecord = await store.find('user', user.username);
          console.log(`[Wrapper] Received user record for ${user.username}:`, userRecord);
          return userRecord;
        })
      );
      
      console.log('[Wrapper] All detailed user records:', detailedData);
      this.detailedUsers = detailedData;
    } catch (error) {
      console.error("[Wrapper] Error fetching detailed user data:", error);
      this.detailedUsers = moderators; // Fallback to basic moderator data
    }
  }

  get users() {
    const currentUsers = this.detailedUsers.length > 0 ? this.detailedUsers : (this.args.outletArgs?.model?.moderators || []);
    console.log("[Wrapper] Current users being passed to CustomAboutPageUsers:", currentUsers);
    return currentUsers;
  }

  get truncateAt() {
    // Truncate at 6 items by default
    return 6;
  }

  <template>
    <CustomAboutPageUsers
      @users={{this.users}}
      @truncateAt={{this.truncateAt}}
    />
  </template>
} 