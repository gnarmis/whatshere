module Project
  class TweetsNearMe < Sinatra::Base
    register Sinatra::Synchrony
    Faraday.default_adapter = :em_synchrony
    # set configuration for this app
    configure :production, :development do
    end

    # get '/' do
    #   logger.info "loading index page in foo"
    #   "Hello from foo"
    # end

    # get '/?loc=<lat>,<lon>,<range>'
    get '/?' do
      if params[:q] and params[:loc]
        query = "https://search.twitter.com/search.json?q=" + params[:q] + "&geocode=" + params[:loc] + "&rpp=100&include_entities=true"
      elsif params[:loc]
        query = "https://search.twitter.com/search.json?q=%20&geocode=" + params[:loc] + "&rpp=100&include_entities=true"
      elsif params[:q]
        query = "https://search.twitter.com/search.json?q=" + params[:q] +  "&rpp=100&include_entities=true"
      end
      res = Faraday.get query
      content_type :json
      res.body
    end

    get '/top_hashtags?' do
      if params[:loc]
        query = "https://search.twitter.com/search.json?q=%20&geocode=" + params[:loc] + "&rpp=100&include_entities=true"
        res = Faraday.get query
        @results = JSON(res.body)
        @results = @results['results']
        ary = []
        @results.each do |i|
          puts i['entities']
        end
        ary
      end
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