import Component from "@glimmer/component";
import CustomAboutPageUsers from "./custom-about-page-users";

export default class CustomAboutAfterModeratorsWrapper extends Component {
  get users() {
    // Extract moderators list from outletArgs.model
    return this.args.outletArgs?.model?.moderators || [];
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