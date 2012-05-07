module Project
  class PhotosNearMe < Sinatra::Base
    register Sinatra::Synchrony
    Faraday.default_adapter = :em_synchrony
    # KEYPATH = '/Users/g13singh/Development/web/NewsHereAPIKeys.yml'
    # yml = YAML::load(File.open(KEYPATH))
    # set configuration for this app
    configure :production, :development do
    end

    # get '/' do
    #   logger.info "loading index page in foo"
    #   "Hello from foo"
    # end

    # get '/?loc=<lat>,<lon>,<range>'
    get '/?' do
      # q = "http://search.twitter.com/search.json?q=pic&geocode=#{params[:loc]}&rpp=50&include_entities=true"
      q = "http://search.twitter.com/search.json?q=pic.twitter.com&geocode=#{params[:loc]}&result_type=recent&rpp=50&include_entities=true"
      res = Faraday.get q
      content_type :json
      res.body
      # #resource = "https://api.instagram.com/v1/media/search?"
      # query = resource+"lat="+params[:lat]+"&lng="+params[:lng]+"&access_token="+
      # res = Faraday.get query
      # content_type :json
      # res.body
    end
    
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