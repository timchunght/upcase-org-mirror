require "rails_helper"

describe VideoTutorialsController do
  context "show" do
    it "renders the show_licensed page if the user has licensed" do
      user = create(:user)
      license = create_license(:video_tutorial, user)
      sign_in_as user

      get :show, id: license.licenseable

      expect(response).to render_template "show_licensed"
    end

    it 'renders the show page if a user has not licensed' do
      user = create(:user)
      license = create_license(:video_tutorial)
      sign_in_as user

      get :show, id: license.licenseable

      expect(response).to render_template "show"
    end
  end
end
