import { apiInitializer } from "discourse/lib/api";
import CustomAboutWrapper from "../custom-about-wrapper";

export default apiInitializer((api) => {
  // Render our custom admins list into the about-after-admins outlet
  api.renderInOutlet("about-after-admins", CustomAboutWrapper);
  
  // Render our custom moderators list into the about-after-moderators outlet
  api.renderInOutlet("about-after-moderators", CustomAboutWrapper);
}); 