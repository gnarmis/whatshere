module Project
  class Client < Sinatra::Base
    register Sinatra::Synchrony
    register Sinatra::Contrib
    Faraday.default_adapter = :em_synchrony
    # set configuration for this app
    configure :production, :development do
    end

    set :root, File.dirname(__FILE__)
    set :static, true

    get '/' do
      redirect '/index.html'
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
    end

  end
end