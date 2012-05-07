require 'spec_helper'

describe Project::TweetsNearMe do

  def app
    @app ||= Project::TweetsNearMe
    Capybara.app = Project::TweetsNearMe
  end

  describe "GET '/'" do
    it "should be successful" do
      get '/'
      last_response.status == 200
    end
  end

end
