import { apiInitializer } from "discourse/lib/api";
import CustomAboutAdmins from "../custom-about-admins";
import CustomAboutModerators from "../custom-about-moderators";

export default apiInitializer("1.13.0", (api) => {
  // Render our custom admins list into the about-after-admins outlet
  api.renderInOutlet("about-after-admins", CustomAboutAdmins);
  
  // Render our custom moderators list into the about-after-moderators outlet
  api.renderInOutlet("about-after-moderators", CustomAboutModerators);
}); 