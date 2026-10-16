# frozen_string_literal: true

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

  context "with the New list" do
    let!(:user) { Fabricate(:user) }
    let!(:category) { Fabricate(:category) }
    let!(:normal_topic) { Fabricate(:topic) }
    let!(:suppressed_topic) { Fabricate(:topic, category: category) }

    before { SiteSetting.categories_suppressed_from_latest = "#{category.id}" }

    it "removes topics from suppressed categories globally" do
      ids = TopicQuery.new(user).list_new.topics.map(&:id)

      expect(ids).to include(normal_topic.id)
      expect(ids).not_to include(suppressed_topic.id)
    end

    it "shows them when viewing the suppressed category itself" do
      ids = TopicQuery.new(user, category: category.id).list_new.topics.map(&:id)

      expect(ids).to include(suppressed_topic.id)
    end
  end
end