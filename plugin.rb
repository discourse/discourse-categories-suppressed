# frozen_string_literal: true

# name: discourse-categories-suppressed
# about: Suppress categories from latest topics page.
# version: 0.1
# url: https://github.com/vinothkannans/discourse-categories-suppressed

after_initialize do

  if TopicQuery.respond_to?(:results_filter_callbacks)
    remove_suppressed_category_topics = Proc.new do |list_type, result, user, options|
      category_ids = (SiteSetting.categories_suppressed_from_latest.presence || "").split("|").map(&:to_i)

      if category_ids.blank? || list_type != :latest || options[:category] || options[:tags]
        result
      else
        result.where("topics.category_id NOT IN (#{category_ids.join(",")})")
      end
    end

    TopicQuery.results_filter_callbacks << remove_suppressed_category_topics
  end

end
