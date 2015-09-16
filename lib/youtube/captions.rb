require 'uri'
require 'net/http'
require 'active_support/core_ext/object/to_query'

module Youtube
  class Captions
    def initialize(api_key: nil)
      @host = 'video.google.com'
      @path = '/timedtext'
      @query = {
          :lang => 'en',
          :format => 'srt'
      }
    end

    def get_captions(video_id)
      uri = create_uri(video_id)
      send_request(uri)
    end

    private
    def create_uri(video_id)
      URI::HTTP.build(:host => @host, :path => @path, :query => @query.merge({:v => video_id}).to_query)
    end

    def send_request(uri)
      #uri
      Net::HTTP.get(uri)
    end
  end
end