# frozen_string_literal: true

require "rails_helper"

describe Decidim::UpdateAccount do
  subject(:command) { described_class.new(form) }

  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization:) }
  let(:original_email) { user.email }
  let(:form) do
    Decidim::AccountForm.from_params(
      name: user.name,
      nickname: user.nickname,
      email: "attacker@example.org",
      locale: "en"
    ).with_context(
      current_organization: organization,
      current_user: user
    )
  end

  before { original_email }

  describe "when called with a different email in the form" do
    it "does not change the user's email" do
      expect { command.call }.not_to change { user.reload.email }
    end

    it "broadcasts :ok" do
      expect { command.call }.to broadcast(:ok)
    end
  end
end
