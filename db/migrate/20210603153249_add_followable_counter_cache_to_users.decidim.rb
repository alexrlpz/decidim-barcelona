# frozen_string_literal: true
# This migration comes from decidim (originally 20210310120640)

class AddFollowableCounterCacheToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_users, :follows_count, :integer, null: false, default: 0, index: true

=begin
    # This is too slow, it will be done after running all the migrations
    reversible do |dir|
      dir.up do
        Decidim::User.reset_column_information
        Decidim::User.find_each do |record|
          record.class.reset_counters(record.id, :follows)
        end
      end
    end
=end
  end
end
