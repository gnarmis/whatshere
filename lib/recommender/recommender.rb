module Project
  class Recommender < Sinatra::Base
    register Sinatra::Synchrony
    Faraday.default_adapter = :em_synchrony
    # set configuration for this app
    configure :production, :development do
      set :root, File.dirname(__FILE__)
      set :static, true
    end

    before do
      content_type :json
    end

    get '/?' do
      res = ""
      q = "http://api.hunch.com/api/v1/get-recommendations/?"
      if params[:tw] and params[:lat] and params[:lng]
        q +=  "user_id=tw_#{params[:tw]}&lat=#{params[:lat]}&lng=#{params[:lng]}&radius=3.0&limit=20"
      elsif params[:lat] and params[:lng] and !params[:tw] and !params[:result_ids]
        q +=  "lat=#{params[:lat]}&lng=#{params[:lng]}&radius=3.0&limit=20"
      elsif params[:result_ids]
        q += "result_ids=#{params[:result_ids]}"
      end
      r = Faraday.get q
      res += r.body
      res
    end

    # returns only topics associated with each result
    get '/topics?' do
      topics = []
      if params[:tw] and params[:lat] and params[:lng]
        r = Faraday.get "http://api.hunch.com/api/v1/get-recommendations/?user_id=tw_#{params[:tw]}&lat=#{params[:lat]}&lng=#{params[:lng]}&radius=3.0&limit=50"
        # res += r.body
        j = JSON(r.body)
        j['recommendations'].each do |r|
          if r['topic_ids'].last # if there are some topic_ids...
            topics.push [r['topic_ids'].last, 
                        munge_topic_name(r['topic_ids'].last)]
          end
        end
        a = topics
        h = {}
        i = 0
        topics.each do |t|
          h[a[i]] ||= 0
          h[a[i]] += 1
          i+=1
        end
      end
      h = h.sort_by {|k, v| v}.reverse
      h.to_json
    end

    helpers do
      def munge_topic_name(str)
        # puts "str: #{str}"
        s = str.to_s.split('_').last
        s.to_s.tr('-', ' ')
        # puts "s: #{s}"
        # s
      end
    end

  end
end