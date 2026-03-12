## ADDED Requirements

### Requirement: Email address is immutable on account edit
The system SHALL prevent users from updating their email address when editing their account profile. The email field SHALL be rendered as disabled in the account edit form, and any email value submitted via the form SHALL be discarded; the current user's email SHALL remain unchanged.

#### Scenario: Email field is rendered as disabled
- **WHEN** a user visits the account edit page
- **THEN** the email input field SHALL be rendered with the `disabled` attribute so users cannot type into it

#### Scenario: Submitted email change is silently discarded
- **WHEN** a user submits the account edit form with a different email address
- **THEN** the user's email SHALL remain equal to the original value and no email update SHALL be persisted

#### Scenario: Form validation does not require old password for email change
- **WHEN** a user submits the account edit form with only non-email fields changed (no password change)
- **THEN** the form SHALL be valid without requiring the old password field, because the email is treated as unchanged

#### Scenario: Account can still be saved when email field is populated differently
- **WHEN** a user submits the account edit form with a valid name, nickname, and a different email value
- **THEN** the form SHALL succeed and save the name/nickname changes while the email SHALL remain unchanged

### Requirement: Automated test coverage for email blocking
The implementation SHALL be covered by automated tests verifying both the server-side override behaviour and the rendered UI state.

#### Scenario: Form override unit test passes
- **WHEN** `AccountFormOverride` is included and the form is built with a different email value
- **THEN** calling `form.email` SHALL return the current user's email, not the submitted value

#### Scenario: Command override unit test passes
- **WHEN** `UpdateAccountOverride` is included and `UpdateAccount` is called with a form carrying a different email
- **THEN** the user's email attribute SHALL remain unchanged after the command executes

#### Scenario: System test confirms disabled field
- **WHEN** a logged-in user visits the account edit page
- **THEN** the email input field SHALL have the `disabled` HTML attribute
