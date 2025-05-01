import avatar from "discourse/helpers/avatar";
import { prioritizeNameInUx } from "discourse/lib/settings";
import { userPath } from "discourse/lib/url";
import { i18n } from "discourse-i18n";
import { htmlSafe } from "@ember/template";
import dIcon from "discourse/helpers/d-icon";

const CustomAboutPageUser = <template>
  <div class="custom-about-page-user" data-username={{@user.username}}>
    <div class="user-avatar">
      <a
        href={{userPath @user.username}}
        data-user-card={{@user.username}}
        aria-hidden="true"
      >
        {{avatar @user imageSize="huge"}}
      </a>
    </div>
    
    <div class="user-details">
      <h4 class="username">
        <a
          href={{userPath @user.username}}
          data-user-card={{@user.username}}
          aria-label={{i18n "user.profile_possessive" username=@user.username}}
        >
          {{#if (prioritizeNameInUx @user.name)}}
            {{@user.name}}
          {{else}}
            {{@user.username}}
          {{/if}}
        </a>
      </h4>
      
      {{#if @user.title}}
        <div class="user-title">{{@user.title}}</div>
      {{/if}}
      
      {{#if @user.bio_cooked}}
        <div class="user-bio">{{htmlSafe @user.bio_cooked}}</div>
      {{/if}}
      
      <div class="user-social-links">
        <a href={{userPath @user.username}} class="social-link">
          {{dIcon "fab-discourse"}}
        </a>
        {{#if @user.website}}
          <a href={{@user.website}} target="_blank" rel="noopener noreferrer" class="social-link">
            {{dIcon "globe"}}
          </a>
        {{/if}}
      </div>
    </div>
  </div>
</template>;

export default CustomAboutPageUser;