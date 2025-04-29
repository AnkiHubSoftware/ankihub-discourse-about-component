import avatar from "discourse/helpers/avatar";
import { prioritizeNameInUx } from "discourse/lib/settings";
import { userPath } from "discourse/lib/url";
import { i18n } from "discourse-i18n";
import { htmlSafe } from "@ember/template";

const CustomAboutPageUser = <template>
  {{#let @user as |user|}}
    {{log "[User Component] Rendering user:" user.username}}
    {{log "[User Component] Bio cooked status for " user.username ":" (if user.bio_cooked "Present" "Not present")}}
    {{#if user.bio_cooked}}
      {{log "[User Component] Bio content for " user.username ":" user.bio_cooked}}
    {{/if}}
  {{/let}}
  <div data-username={{@user.username}} class="user-info small">
    <div class="user-image">
      <div class="user-image-inner">
        <a
          href={{userPath @user.username}}
          data-user-card={{@user.username}}
          aria-hidden="true"
        >
          {{avatar @user imageSize="large"}}
        </a>
      </div>
    </div>
    <div class="user-detail">
      <div class="name-line">
        <a
          href={{userPath @user.username}}
          data-user-card={{@user.username}}
          aria-label={{i18n "user.profile_possessive" username=@user.username}}
        >
          <span class="username">
            {{#if (prioritizeNameInUx @user.name)}}
              {{@user.name}}
            {{else}}
              {{@user.username}}
            {{/if}}
          </span>
          <span class="name">
            {{#if (prioritizeNameInUx @user.name)}}
              {{@user.username}}
            {{else}}
              {{@user.name}}
            {{/if}}
          </span>
        </a>
      </div>
      <div class="title">{{@user.title}}</div>
      {{#if @user.bio_cooked}}
        <div class="bio">{{htmlSafe @user.bio_cooked}}</div>
      {{/if}}
    </div>
  </div>
</template>;

export default CustomAboutPageUser;