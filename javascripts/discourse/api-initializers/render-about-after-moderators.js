import { apiInitializer } from "discourse/lib/api";
import CustomModeratorsSection from "../components/custom-moderators-section";

export default apiInitializer((api) => {
  // Render our custom moderators list into the about-after-moderators outlet
  api.renderInOutlet("about-after-moderators", CustomModeratorsSection);
});
