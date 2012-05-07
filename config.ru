require File.dirname(__FILE__) + '/config/boot.rb'

run Rack::URLMap.new({
  "/"                => Project::MobileClient,
  "/tweetsnearme"    => Project::TweetsNearMe,
  "/photosnearme"    => Project::PhotosNearMe,
  "/placesnearme"    => Project::PlacesNearMe,
  "/rec"             => Project::Recommender,
  "/m"               => Project::MobileClient
})
