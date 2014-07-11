class Page
  require 'open-uri'
  require 'uri'
  require 'json'
  require 'nokogiri'

  attr_accessor :url

  def initialize url
    @url = url
  end

  def twitter_count
    request_url = "http://urls.api.twitter.com/1/urls/count.json?url=#{@url}"
    JSON.parser.new(open(request_url).read).parse["count"].to_i
  end

  def facebook_count
    request_url = "https://graph.facebook.com/?id=#{@url}"
    JSON.parser.new(open(request_url).read).parse["shares"].to_i
  end

  def hatena_count
    request_url = "http://api.b.st-hatena.com/entry.count?url=#{@url}"
    p request_url
    open(request_url).read.to_i
  end

  def google_count
    key = 'AIzaSyCKSbrvQasunBoV16zDH9R33D88CeLr9gQ'
    api = URI.parse("https://clients6.google.com/rpc?key=#{key}")

    request = Net::HTTP::Post.new(api.request_uri, {
        'Content-Type' => 'application/json'
    })
    request.body = [{
                        :jsonrpc => "2.0",
                        :method => "pos.plusones.get",
                        :apiVersion => "v1",
                        :key => "p",
                        :id => "p",
                        :params => {
                            :id => @url,
                            :userId => "@viewer",
                            :groupId => "@self",
                            :nolog => true,
                        },
                    }].to_json

    response = Net::HTTP.start(api.host, api.port, :use_ssl => true) { |http|
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.request(request)
    }

    json = JSON.parse(response.body)
    return json[0]['result']['metadata']['globalCounts']['count'].round
  end

  def pocket_count
    request_url = "https://widgets.getpocket.com/v1/button?label=pocket&count=vertical&align=left&v=1&url=#{@url}&title=&src=#{@url}&r=#{rand(100000000).to_s}"
    html = Nokogiri::HTML open(URI.escape request_url)
    html.search('#cnt').text.to_i
  end

end