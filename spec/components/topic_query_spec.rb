# frozen_string_literal: true

require 'rails_helper'

describe TopicQuery do
  context "suppress categories from latest" do
    let(:category) { Fabricate(:category) }

    before do
      SiteSetting.categories_suppressed_from_latest = "#{category.id}"
    end

    it "removes topics from suppressed categories" do
      topic1 = Fabricate(:topic)
      topic2 = Fabricate(:topic, category: category)

      expect(TopicQuery.new.list_latest.topics.map(&:id)).to eq([topic1.id])
    end
  end
end
