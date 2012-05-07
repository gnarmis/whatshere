require 'spec_helper'

describe Project::PlacesNearMe do

  def app
    @app ||= Project::PlacesNearMe
    Capybara.app = Project::PlacesNearMe
  end

  describe "GET '/'" do
    it "should be successful" do
      get '/'
      last_response.status == 200
    end
  end

end
