require 'bundler'
Bundler.require

class API < Grape::API
  use Rack::JSONP
  format :json

  params do
    requires :url, type: String, regexp: /^https?/
    optional :all, type: Integer, default: 0
  end

  get '/count.json' do
    page = Page.new params[:url]
    if params[:all] == 1 then
      {
          :url => page.url,
          :twitter => page.twitter_count,
          :hatena => page.hatena_count,
          :facebook => page.facebook_count,
          :pocket => page.pocket_count,
          :google => page.google_count
      }
    else
      {
          :url => page.url,
          :pocket => page.pocket_count,
          :google => page.google_count
      }
    end
  end
end