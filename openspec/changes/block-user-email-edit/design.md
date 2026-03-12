## Context

Decidim's account edit page (`Decidim::AccountController#show`) allows users to update their email via `Decidim::AccountForm` and `Decidim::UpdateAccount`. Barcelona's auth is federated through Valid (`decidim-valid_auth`), so the canonical email lives in the external identity provider. Any change made inside Decidim would desync the two systems and break authentication.

The project already has a well-established monkey-patch pattern: create a concern under `app/*/concerns/`, register it in `config/initializers/decidim_overrides.rb`, and add a checksum entry to `spec/lib/overrides_spec.rb` so CI catches upstream drift.

## Goals / Non-Goals

**Goals:**
- Prevent any submitted email value from being persisted when a user edits their account.
- Render the email field as disabled in the view so users cannot interact with it.
- Keep the existing pattern consistent (concerns, registrations, checksums).

**Non-Goals:**
- Blocking admin-side email changes.
- Any changes to the password-change flow.

## Decisions

### 1. Override at form level AND command level

**Decision:** Lock email in both `AccountForm#email` and `UpdateAccount#update_personal_data`.

**Why:** Defence in depth. The form override ensures the email value seen by validations is always the current user's email (so `validate_old_password` and `unique_email` never complain). The command override ensures the field is never assigned to the model even if the form override is somehow bypassed.

**Alternative considered:** Override only the command. Rejected because validation errors (e.g. `validate_old_password` requiring old password when email appears to change) would surface to the user confusingly if the form still passed a different email value to validations.

### 2. Use `include` + `included do` (not `prepend`)

**Decision:** Register both overrides with `include`.

**Why:** The `included do` block reopens and redefines the method directly on the target class, which is the pattern used by all other non-permission overrides in the project. `prepend` is reserved for the cases already using it (`Permissions`, `SearchResourceFieldsMapper`, PDF exporters). Consistency matters for maintainability.

### 3. Disable email field in the view via a copied view override

**Decision:** Copy `decidim-core`'s `app/views/decidim/account/show.html.erb` into the project and change the email field's `disabled` attribute from `current_user.unconfirmed_email.present?` to `true`.

**Why:** The email field is already conditionally disabled upstream; we just need it always disabled. Copying the view file follows Decidim's standard view override approach and keeps the change minimal. The checksum entry in `overrides_spec.rb` will catch any upstream drift to this file.

## Risks / Trade-offs

- **Upstream change in `AccountForm`, `UpdateAccount`, or `show.html.erb`**: The checksum spec will fail, alerting developers to review the override. Mitigation: checksums added to `spec/lib/overrides_spec.rb`.
- **View override drift**: Copying the full view means any upstream improvements (accessibility, new fields) require manual merging. Mitigation: checksum spec catches it; the change to the email line is minimal so merging is low-effort.
- **`validate_old_password` side-effect**: The original method requires `old_password` when `user.email != email`. By always returning `current_user.email` from the form, this branch is never entered, so password is only required when explicitly changing it. This is the correct behaviour and a net improvement.

## Migration Plan

1. Add the two concern files (form and command overrides).
2. Register them in the initializer.
3. Copy `decidim-core`'s `app/views/decidim/account/show.html.erb` into the project and set the email field's `disabled` attribute to `true`.
4. Add checksum entries for all three overridden files to `spec/lib/overrides_spec.rb`.
5. Run `bundle exec rspec spec/lib/overrides_spec.rb` to confirm checksums match.
6. No deployment steps beyond a normal deploy (no DB migrations, no cache flush needed).

**Rollback:** Remove the two `include` lines from the initializer, delete the concern files, and remove the copied view file.
