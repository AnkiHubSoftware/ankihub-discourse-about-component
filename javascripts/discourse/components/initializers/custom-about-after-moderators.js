import { apiInitializer } from "discourse/lib/api";
import CustomAboutAfterModeratorsWrapper from "../custom-about-after-moderators-wrapper";

export default apiInitializer((api) => {
  // Render our custom moderators list into the about-after-moderators outlet
  api.renderInOutlet("about-after-moderators", CustomAboutAfterModeratorsWrapper);
}); 