# frozen_string_literal: true

require "rails_helper"

describe Decidim::AccountForm do
  subject(:form) { described_class.from_params(params).with_context(context) }

  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization:) }
  let(:context) do
    {
      current_organization: organization,
      current_user: user
    }
  end
  let(:params) do
    {
      name: user.name,
      nickname: user.nickname,
      email: "attacker@example.org",
      locale: "en"
    }
  end

  describe "#email" do
    it "returns the current user's email regardless of submitted value" do
      expect(form.email).to eq(user.email)
    end

    it "does not return the submitted email value" do
      expect(form.email).not_to eq("attacker@example.org")
    end
  end
end
