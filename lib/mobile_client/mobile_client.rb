module Project
  class MobileClient < Sinatra::Base
    register Sinatra::Synchrony
    register Sinatra::Contrib
    Faraday.default_adapter = :em_synchrony
    # set configuration for this app
    configure :production, :development do
    end

    set :root, File.dirname(__FILE__)
    set :static, true

    Slim::Engine.set_default_options :disable_escape => true

    get '/' do
      slim :index
    end

    post '/submit' do
      lat = format_gps(params[:geo_lat])
      lon = format_gps(params[:geo_lon])
      @tw = params[:tw_id]
      @lat = lat
      @lng = lon
      # names = ""
      # @results.each do |i|
      #   names += '<li data-split-theme="d"><h3>' + i['name'] + "</h3> <p>" + i['street'] + "</p></li>"
      # end
      # @names = names
      slim :all
    end

    # get results about a specific topic
    get '/topic' do
      @results = {}.to_json
      if params[:topic] and params[:tw] and params[:lat] and params[:lng]
        r = Faraday.get "http://api.hunch.com/api/v1/get-recommendations/?" + 
                        "user_id=tw_#{params[:tw]}&lat=#{params[:lat]}&lng=#{params[:lng]}"+
                        "&radius=1.0&topic_ids=#{params[:topic]}&limit=10"
        @results = JSON(r.body)
        @topic_id = params[:topic]
        @results = @results['recommendations']
      end
      slim :topic_list
    end


    get '/all?' do
      if params[:tw_id] and params[:geo_lat] and params[:geo_lon]
        lat = format_gps(params[:geo_lat])
        lon = format_gps(params[:geo_lon])
        @tw = params[:tw_id]
        @lat = lat
        @lng = lon
        slim :all
      end
    end

    get '/place?' do
      if params[:result_id] and params[:topic_ids]
        q = base_url+"/rec/?result_ids=#{params[:result_id]}&topic_ids=#{params[:topic_ids]}"
        #puts q
        res = Faraday.get q
        @r = JSON(res.body)
        @result = @r['recommendations']
        @result = @result[0]
        @topic = params[:topic_ids]
        slim :place
      end
    end

    get '/places?' do
      if params[:tw] and params[:lat] and params[:lng]
        q = base_url+"/rec/topics?tw=#{params[:tw]}&lat=#{params[:lat]}&lng=#{params[:lng]}"
        #puts q
        res = Faraday.get q
        @r = JSON.parse(res.body)
        @results = []
        @r.each do |i|
          @results.push i[0]
        end
        @link_base = "/topic?tw=#{params[:tw]}&lat=#{params[:lat]}&lng=#{params[:lng]}"
        slim :places
      end
    end

    get '/tweets?' do
      if params[:lat] and params[:lng]
        q = base_url+"/tweetsnearme/?loc=#{params[:lat]},#{params[:lng]},0.2mi"
        res = Faraday.get q
        @results = []
        @r = JSON(res.body)
        @r['results'].each do |i|
          @results.push i
        end
        slim :tweets
      end
    end

    get '/person' do
      "It's a person!"
    end

    get '/people?' do
      if params[:lat] and params[:lng]
        q = base_url+"/tweetsnearme/?loc=#{params[:lat]},#{params[:lng]},0.2mi"
        res = Faraday.get q
        @results = []
        @r = JSON(res.body)
        @r['results'].each do |i|
          @results.push i
        end
        slim :people
      end
    end

    get '/photos?' do
      if params[:lat] and params[:lng]
        q = base_url+"/photosnearme/?loc=#{params[:lat]},#{params[:lng]},2.0mi"
        res = Faraday.get q
        @results = []
        @r = JSON(res.body)
        @r['results'].each do |i|
          if i['entities'] and i['entities']['media']
            @results.push i['entities']['media'][0]
          end
        end
        slim :photos
      end
    end

    helpers do
      def base_url
        @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
      end
      def format_gps(n)
        r = Regexp.new /(-*(([0-9])*)(\.)(([0-9]){6})){1}/
        a = n.match(r)
        a = a.captures[0]
      end
      def url_enc(str)
         URI.escape(str, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      end
    end

  end
end