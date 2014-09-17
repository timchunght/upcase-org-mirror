module ProductsHelper
  def test_driven_rails_url
    "https://upcase.com/video_tutorials/18-test-driven-rails"
  end

  def design_for_developers_url
    "https://upcase.com/video_tutorials/19-design-for-developers"
  end

  def intermediate_rails_url
    "https://upcase.com/video_tutorials/21-intermediate-ruby-on-rails"
  end

  def exercise_link(url, options = {}, &block)
    if current_user_has_access_to?(:exercises)
      link_to url, options, &block
    else
      content_tag "a", &block
    end
  end
end
