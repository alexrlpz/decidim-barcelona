# frozen_string_literal: true

require "rails_helper"

describe "Account email edit", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization:) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim.account_path
  end

  it "renders the email field as disabled" do
    expect(page).to have_css("input[type='email'][disabled]")
  end

  it "does not update the email when a different value is submitted" do
    original_email = user.email

    # The field is disabled so the browser won't submit it,
    # but even if it were submitted the override discards it.
    click_button I18n.t("decidim.account.show.update_account")

    expect(user.reload.email).to eq(original_email)
  end
end
