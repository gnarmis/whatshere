module Project
  class PlacesNearMe < Sinatra::Base
    register Sinatra::Synchrony
    Faraday.default_adapter = :em_synchrony
    # KEYPATH = '/Users/g13singh/Development/web/NewsHereAPIKeys.yml'
    # yml = YAML::load(File.open(KEYPATH))
    # GooglePlacesAPIKey = yml['GooglePlacesAPIKey']
    # FourSquareClientID = yml['FourSquareClientID']
    # FourSquareClientSecret = yml['FourSquareClientSecret']

    # # set configuration for this app
    # configure :production, :development do
    # end

    # # get '/' do
    # #   logger.info "loading index page in foo"
    # #   "Hello from foo"
    # # end

    # before do
    #   status 200
    #   content_type :json
    # end
    # # example: GET /revgc?lat=41.89581&lon=-87.635818
    # get '/revgc?' do
    #   res = []
    #   if params[:lat] and params[:lon]
    #     Geokit::Geocoders::google = GooglePlacesAPIKey
    #     a = Geokit::Geocoders::GoogleGeocoder.reverse_geocode(params[:lat]+','+ 
    #                                                           params[:lon])
    #     res << {
    #       :provider => a.provider,
    #       :address => a.full_address,
    #       :ll => a.ll
    #     }
    #   end
    #   res.to_json
    # end

    # # example: GET /gp?lat=41.89581&lon=-87.635818
    # get '/gp?' do
    #   res = []
    #   if params[:lat] and params[:lon]
    #     @client = GooglePlaces::Client.new(GooglePlacesAPIKey)
    #     spots = @client.spots(params[:lat].to_f, params[:lon].to_f)
    #     spots.each do |e|
    #       res << {:name       => e.name,
    #               :lat        => e.lat,
    #               :lon        => e.lng,
    #               :distance   => appox_dist(e.lat, 
    #                                         e.lng, 
    #                                         params[:lat].to_f, 
    #                                         params[:lon].to_f),
    #               :vicinity   => e.vicinity,
    #               :types      => e.types,
    #               :reference    => e.reference,
    #               :addr_comps => e.address_components,
    #               :phone      => e.formatted_phone_number}
    #     end
    #   end
    #   res.to_json
    # end

    # # example: GET /fs?lat=41.89581&lon=-87.635818
    # get '/fs?' do
    #   res = []
    #   if params[:lat] and params[:lon]
    #     @fc = Foursquare2::Client.new(:client_id => FourSquareClientID, 
    #                                   :client_secret => FourSquareClientSecret)
    #     venues = @fc.search_venues( :ll => params[:lat].to_s+','+params[:lon].to_s)
    #     res << venues
    #   end
    #   res.to_json
    # end

    # # example: GET /places?lat=41.89581&lon=-87.635818
    # get '/places?' do
    #   res = []
    #   if params[:lat] and params[:lon]
    #     r = Faraday.get  base_url +
    #                         '/placesnearme/revgc?lat='+
    #                         params[:lat] + '&lon=' +
    #                         params[:lon]
    #     res << { :rev_geo => JSON.parse(r.body) }
    #     r = Faraday.get  base_url +
    #                         '/placesnearme/gp?lat='+
    #                         params[:lat] + '&lon=' +
    #                         params[:lon]
    #     res << { :google_places => JSON.parse(r.body) }
    #     r = Faraday.get  base_url +
    #                         '/placesnearme/fs?lat='+
    #                         params[:lat] + '&lon=' +
    #                         params[:lon]
    #     res << { :foursquare => JSON.parse(r.body) }
    #   end
    #   res.to_json
    # end

    
    # helpers do
    #   def appox_dist(lat1, lon1, lat2, lon2)
    #     x = 69.1 * (lat2 - lat1)
    #     y = 69.1 * (lon2 - lon1) * Math.cos(lat1/57.3)
    #     dist = Math.sqrt(x * x + y * y)
    #     dist.to_s + "mi"
    #   end
    #   def base_url
    #     @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    #   end
    # end


    # I did this to be able to wrap my app in Rack::Auth::Digest for example
    ## Example:
    ## def self.new(*)
    ##  app = Rack::Auth::Digest::MD5.new(super) do |username|
    ##    {'foo' => 'bar'}[username]
    ##  end
    ##  app.realm = 'Foobar::Foo'
    ##  app.opaque = 'secretstuff'
    ##  app
    ## end   
    
    def self.new(*)
      super
    end
    
  end
end