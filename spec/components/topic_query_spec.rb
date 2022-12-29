# frozen_string_literal: true

require "rails_helper"

describe TopicQuery do
  context "with suppress categories from latest configured" do
    let(:category) { Fabricate(:category) }

    before { SiteSetting.categories_suppressed_from_latest = "#{category.id}" }

    it "removes topics from suppressed categories" do
      topic1 = Fabricate(:topic)
      topic2 = Fabricate(:topic, category: category)

      expect(TopicQuery.new.list_latest.topics.map(&:id)).to eq([topic1.id])
    end
  end
end
