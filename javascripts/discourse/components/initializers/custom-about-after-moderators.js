import { apiInitializer } from "discourse/lib/api";
import CustomAboutPageUsers from "../custom-about-page-users";

export default apiInitializer((api) => {
  // Render our custom moderators list into the about-after-moderators outlet
  api.renderInOutlet("about-after-moderators", CustomAboutPageUsers);
});