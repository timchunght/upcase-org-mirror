require "rails_helper"

describe ProductsHelper do
  describe "#exercise_link" do
    context "with access to exercises" do
      it "renders a link to the exercise url" do
        stub_access(exercises: true)
        url = "http://example.com/some/exercise"

        result = helper.exercise_link(url, class: "amazing") { "text" }

        expect(result).to have_css("a.amazing:contains('text')[href='#{url}']")
      end
    end

    context "without access to exercises" do
      it "renders a link to the change plan page" do
        stub_access(exercises: false)
        provided_url = "http://example.com"
        expected_url = edit_subscription_path

        result = helper.exercise_link(provided_url, class: "amazing") { "text" }

        expect(result).
          to have_css("a.amazing:contains('text')[href='#{expected_url}']")
      end
    end
  end

  def stub_access(features)
    features.each do |name, access|
      Mocha::Configuration.allow(:stubbing_non_existent_method) do
        helper.stubs(:current_user_has_access_to?).with(name).returns(access)
      end
    end
  end
end
