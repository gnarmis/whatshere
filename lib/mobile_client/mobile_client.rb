require "date"

module Project
  class MobileClient < Sinatra::Base
    register Sinatra::Synchrony
    register Sinatra::Contrib
    Linguistics.use :en
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
        if @results == nil
          r = Faraday.get "http://api.hunch.com/api/v1/get-recommendations/?" + 
                          "lat=#{params[:lat]}&lng=#{params[:lng]}"+
                          "&radius=1.0&topic_ids=#{params[:topic]}&limit=10"
          @results = JSON(r.body)
          @results = @results['recommendations']
        end
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

    get '/digest?' do
      if params[:tw_id] and params[:geo_lat] and params[:geo_lon]
        lat = format_gps(params[:geo_lat])
        lon = format_gps(params[:geo_lon])
        @tw = params[:tw_id]
        @lat = lat
        @lng = lon
        q = base_url+"/rec/?tw=#{@tw}&lat=#{@lat}&lng=#{@lng}"
        res = Faraday.get q
        @r = JSON(res.body)
        @results = @r['recommendations']
        if @results == nil
          q = base_url+"/rec/?lat=#{@lat}&lng=#{@lng}"
          res = Faraday.get q
          @r = JSON(res.body)
          @results = @r['recommendations']
        end
        strings = []
        @results.each do |i|
          @topics ||= {} # holds actual topics; keys are topic names, values are arrays of specific entries and their info
          if i['topic_ids'] and i['topic_ids'][-1] =~ /_/
            s = i['topic_ids'][-1].split('_')[1].tr('-',' ') 
            s = "coffee shop" if s == "starbucks"
            r = /((.)+(\ )+s)+(\ )/
            s = s.match(r).to_s.rstrip.tr(' ','\'') + " " + s.gsub(s.match(r).to_s, '')
            # s = "women's clothing store" if s == "women s clothing store"
            strings.push s
            @topics[s] ||= []
            if @topics[s] and !(@topics[s].count > 2) and i['tags']
              @topics[s] = @topics[s].push("#{i['title']},#{i['tags'].join(' ')},#{i['result_id']}") 
            end
          end
        end
        # remove all topics that are merely specific versions of others (like "thai restaurants" vs "restaurants")
        strings = strings.uniq
        @reduced_topics = {}
        @num_topics = 0
        @topics.each do |k,v|
          flag = true
          strings.each do |str|
            flag = false if k != str and k.include? str
          end
          if flag
            @reduced_topics[k] = v
            @num_topics += 1
          end
        end
        @topics = @reduced_topics
        @link_base = "/topic?tw=#{@tw}&lat=#{@lat}&lng=#{@lng}"
        slim :digest
      end
    end

    # get '/top_places?' do
    #   if params[:tw] and params[:lat] and params[:lng]
        
    #   end
    # end

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

    get '/similar-results?' do
      if params[:result_id] and params[:topic_ids] and params[:lat] and params[:lng]
        q = "http://api.hunch.com/api/v1/get-similar-results/?result_id=#{params[:result_id]}&topic_ids=#{params[:topic_ids]}&lat=#{params[:lat]}&lng=#{params[:lng]}"
        res = Faraday.get q
        @r = JSON(res.body)
        @results = @r['results']
        slim :similar_places
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
        q = base_url+"/tweetsnearme/?loc=#{params[:lat]},#{params[:lng]},0.1mi"
        q = base_url+"/tweetsnearme/?q=#{params[:q]}&loc=#{params[:lat]},#{params[:lng]},10.0mi" if params[:q]
        res = Faraday.get q
        @results = []
        @r = JSON(res.body)
        @r['results'].each do |i|
          @results.push i
        end
        @lat = params[:lat]
        @lng = params[:lng]
        slim :tweets
      elsif params[:q] and !params[:lat] and !params[:lng]
        q = base_url+"/tweetsnearme/?q=" + params[:q]
        res = Faraday.get q
        @results = []
        @r = JSON(res.body)
        @r['results'].each do |i|
          @results.push i
        end
        slim :tweets
      end
    end

    get '/tw?' do
      if params[:id]
        q = "http://api.twitter.com/1/statuses/show.json?id=#{params[:id]}&include_entities=true"
        if params[:lat] and params[:lng]
          q = "http://api.twitter.com/1/statuses/show.json?id=#{params[:id]}&geocode=#{params[:lat]},#{params[:lng]},0.2mi&include_entities=true" 
          @lat = params[:lat]
          @lng = params[:lng]
        end
        res = Faraday.get q
        @r = JSON(res.body)
        slim :tweet
      end
    end

    get '/person?' do
      if params[:tw]
        q = "http://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{params[:tw]}&include_entities=true&contributor_details=true"
        res = Faraday.get q
        @r = JSON(res.body)
        @profile = @r[0]['user'] if @r[0]['user']
        slim :person
      end
    end

    get '/people?' do
      if params[:lat] and params[:lng]
        q = base_url+"/tweetsnearme/?loc=#{params[:lat]},#{params[:lng]},0.2mi"
        res = Faraday.get q
        @results = []
        @r = JSON(res.body)
        # return @r
        @r['results'].each do |i|
          @results.push [i['from_user'],i['from_user_name'],i['profile_image_url']]
        end
        @results.uniq!
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