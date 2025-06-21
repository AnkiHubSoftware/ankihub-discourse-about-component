# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

**Package Management:**
- Use `pnpm` (auto-detected by CI via pnpm-lock.yaml)
- Install dependencies: `pnpm install --frozen-lockfile`
- Bundle install: `bundle install`

**Linting & Code Quality:**
- ESLint: `pnpm eslint --no-error-on-unmatched-pattern {test,javascripts}` (uses eslint.config.mjs)
- Stylelint: `pnpm stylelint --allow-empty-input "{javascripts,desktop,mobile,common,scss}/**/*.scss"` (uses stylelint.config.mjs)
- Prettier: `pnpm prettier --check` on .scss/.js/.gjs/.hbs files
- Ember Template Lint: `pnpm ember-template-lint --no-error-on-unmatched-pattern javascripts`
- Ruby linting: `bundle exec rubocop .` (if .rubocop.yml exists)
- Syntax Tree: `bundle exec stree check` (if .streerc exists)

## Architecture Overview

This is a Discourse theme component that customizes the About page by replacing default admin/moderator sections with custom implementations.

**Component Structure:**
- **Main Components:** Located in `javascripts/discourse/components/`
  - `custom-about-admins.gjs` - Custom admin section with expand/collapse
  - `custom-about-moderators.gjs` - Custom moderator section
  - `custom-about-page-users.gjs` - Generic user list component with truncation
  - `custom-about-page-user.gjs` - Individual user display component

**Key Patterns:**
- All components use Glimmer/GJS format with embedded templates
- Components share common patterns: `@tracked expanded` state, `truncateAt` prop for showing limited users initially
- Uses Discourse's built-in `AboutPageUser` component for consistent user display
- Uses `DButton` with chevron icons for expand/collapse functionality

**Integration Points:**
- `about-after-moderators` connector (empty directory suggests template connector usage)
- `common/common.scss` hides default Discourse sections (`.about__admins`, `.about__moderators`)
- Component registration in `about.json` assets array

**Theme Configuration:**
- `about.json` defines component metadata, minimum Discourse version (3.1.0.beta1)
- `settings.yml` exists but is empty
- SVG icons registered: `fab-discourse`, `globe`

**Development Notes:**
- Components follow Discourse's AboutPageUser pattern for user display consistency  
- Truncation logic is implemented at component level with `truncateAt` argument
- All user lists support expand/collapse functionality with proper i18n labels

## CI/CD Workflow

This theme uses the standard Discourse theme CI workflow which automatically:

**Detection & Setup:**
- Auto-detects pnpm via pnpm-lock.yaml presence
- Runs in discourse/discourse_test Docker containers
- Sets up Ruby, Node.js, PostgreSQL, and Redis

**Test Matrix:**
- **Frontend tests**: Runs QUnit tests if `test/**/*.{js,gjs}` files exist
- **Backend tests**: Runs RSpec tests if `spec/**/*.rb` files exist (non-system)
- **System tests**: Runs system specs if `spec/system/**/*.rb` files exist

**Quality Checks:**
- Validates .es6 files don't exist (should be .js)
- Runs all linting tools (ESLint, Stylelint, Prettier, ember-template-lint)
- Validates discourse-compatibility file if present
- Checks locale files with i18n_lint if locales/en.yml exists

**Theme Installation:**
- Creates theme archive and installs via Discourse's theme system
- Runs theme-specific QUnit tests in full Discourse environment
