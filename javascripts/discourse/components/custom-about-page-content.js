import Component from "@glimmer/component";
import { service } from "@ember/service";

export default class CustomAboutPageContent extends Component {
  @service router;

  get isAboutPage() {
    console.log("Component is loaded");
    return true;
  }
}
