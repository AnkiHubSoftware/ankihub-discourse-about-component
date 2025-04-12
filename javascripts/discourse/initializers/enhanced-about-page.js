import { apiInitializer } from "discourse/lib/plugin-api";

export default apiInitializer("0.11.1", api => {
  console.group("[Enhanced About Page]");
  console.log("🚀 Initializing component...");
  console.log("📌 API Version:", "0.11.1");

  try {
    // Modify the about page component
    api.modifyClass("route:about", {
      pluginId: "enhanced-about-page",
      
      setupController(controller, model) {
        this._super(controller, model);
        console.log("📄 About page route setup", { controller, model });
      }
    });

    // Add bio loading functionality to the user card component
    api.modifyClass("component:user-card-contents", {
      pluginId: "enhanced-about-page-user",
      
      didInsertElement() {
        this._super(...arguments);
        console.log("🎴 User card inserted:", this.user);
        
        if (this.user) {
          this.loadUserBio();
        }
      },

      loadUserBio() {
        const user = this.user;
        if (!user || user.bio_excerpt) return;

        console.log("🔄 Loading bio for user:", user.username);
        
        this.store.find("user", user.username.toLowerCase())
          .then(userModel => {
            console.log("✅ User data fetched:", userModel);
            if (userModel.bio_excerpt) {
              this.set("user.bio_excerpt", userModel.bio_excerpt);
              this.addBioToCard();
            }
          })
          .catch(error => {
            console.error("❌ Error fetching bio:", error);
          });
      },

      addBioToCard() {
        if (!this.element || !this.user?.bio_excerpt) return;

        const userInfo = this.element.querySelector(".user-card-bio");
        if (!userInfo || userInfo.querySelector(".user-bio-content")) return;

        console.log("➕ Adding bio to user card");
        
        const bioContent = document.createElement("div");
        bioContent.className = "user-bio-content";
        bioContent.innerHTML = this.user.bio_excerpt;
        userInfo.appendChild(bioContent);
      }
    });

    console.log("✅ Successfully modified components");
  } catch (error) {
    console.error("❌ Error during component modification:", error);
    console.error("Error details:", {
      name: error.name,
      message: error.message,
      stack: error.stack
    });
  }

  // Add a route observer to detect when we're on the about page
  api.onAppEvent("page:changed", (data) => {
    console.log("📄 Page changed:", data);
    if (data.url === "/about") {
      console.log("📍 On about page - components should activate soon");
    }
  });
  
  console.log("✅ Component initialization complete");
  console.groupEnd();
}); 
