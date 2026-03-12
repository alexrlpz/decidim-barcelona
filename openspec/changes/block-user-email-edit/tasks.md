## 1. Form Override

- [x] 1.1 Create `app/forms/concerns/decidim/account_form_override.rb` with `AccountFormOverride` concern that overrides `email` to return `context.current_user.email`
- [x] 1.2 Register `Decidim::AccountForm.include(Decidim::AccountFormOverride)` in `config/initializers/decidim_overrides.rb`

## 2. Command Override

- [x] 2.1 Create `app/commands/concerns/decidim/update_account_override.rb` with `UpdateAccountOverride` concern that overrides `update_personal_data` to omit the email assignment
- [x] 2.2 Register `Decidim::UpdateAccount.include(Decidim::UpdateAccountOverride)` in `config/initializers/decidim_overrides.rb`

## 3. View Override

- [x] 3.1 Copy `decidim-core`'s `app/views/decidim/account/show.html.erb` to `app/views/decidim/account/show.html.erb` in the project
- [x] 3.2 Change `disabled: current_user.unconfirmed_email.present?` to `disabled: true` on the email field line

## 4. Checksum Tracking

- [x] 4.1 Add checksum entry for `decidim-core` `/app/forms/decidim/account_form.rb` to `spec/lib/overrides_spec.rb`
- [x] 4.2 Add checksum entry for `decidim-core` `/app/commands/decidim/update_account.rb` to `spec/lib/overrides_spec.rb`
- [x] 4.3 Add checksum entry for `decidim-core` `/app/views/decidim/account/show.html.erb` to `spec/lib/overrides_spec.rb`

## 5. Tests

- [x] 5.1 Create `spec/forms/decidim/account_form_override_spec.rb` — unit test that `form.email` returns `current_user.email` when a different email is passed to the form
- [x] 5.2 Create `spec/commands/decidim/update_account_override_spec.rb` — unit test that calling `UpdateAccount` does not change the user's email attribute
- [x] 5.3 Create `spec/system/account_email_edit_spec.rb` — system test that the email field on the account edit page has the `disabled` attribute

## 6. Verification

- [x] 6.1 Run `bundle exec rspec spec/lib/overrides_spec.rb` and confirm all checksum tests pass
- [x] 6.2 Run `bundle exec rspec spec/forms/decidim/account_form_override_spec.rb spec/commands/decidim/update_account_override_spec.rb spec/system/account_email_edit_spec.rb` and confirm all tests pass
