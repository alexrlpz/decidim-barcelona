# frozen_string_literal: true

module Decidim
  module AccountFormOverride
    extend ActiveSupport::Concern

    included do
      def email
        context.current_user.email
      end
    end
  end
end
