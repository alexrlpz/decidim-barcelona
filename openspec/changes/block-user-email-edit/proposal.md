## Why

Barcelona's authentication is managed externally via the Valid auth system (`decidim-valid_auth`). Allowing users to change their email in the account settings form would desync it from the external identity provider and break auth flows. This must be blocked at the application level.

## What Changes

- Override `Decidim::AccountForm` so the `email` attribute is locked to the current user's email — changes submitted via the form are ignored and no email-related validations fire for the email field.
- Override `Decidim::UpdateAccount` command so `update_personal_data` never assigns a new email to the user.
- Override the account edit view to render the email field as disabled/read-only so users cannot interact with it.
- Register both Ruby overrides in `config/initializers/decidim_overrides.rb` (following the existing pattern).
- Add checksum entries for overridden gem files to `spec/lib/overrides_spec.rb` to detect upstream changes.

## Capabilities

### New Capabilities
- `block-account-email-edit`: Users cannot update their email address when editing their account profile. The email field is rendered as disabled in the form, and any submitted value is discarded server-side; the current user's email is always preserved.

### Modified Capabilities
<!-- none — no existing specs change requirements -->

## Impact

- `Decidim::AccountForm` (`decidim-core`) — `email` attribute becomes read-only (derived from `current_user`).
- `Decidim::UpdateAccount` (`decidim-core`) — `update_personal_data` no longer sets `current_user.email`.
- Account edit view (`decidim-core`) — email field rendered with `disabled` attribute.
- `config/initializers/decidim_overrides.rb` — two new lines.
- `spec/lib/overrides_spec.rb` — checksum entries for overridden gem files under `decidim-core`.
- No DB migrations needed. No API impact.
