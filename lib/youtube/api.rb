require 'googleauth'
require 'google/apis/youtube_v3'

module Youtube
  class Api
    Youtube = Google::Apis::YoutubeV3

    def initialize(api_key: nil)
      @youtube = Youtube::YouTubeService.new
      @youtube.key = api_key || 'YOUR_API_KEY'
    end

    def get_upload_channel(username)
      upload_channel = nil

      puts 'Channels:'

      channels = list_channels(username)
      channels.items.each do |item|
        puts "# #{item.id}"
        puts "- uploads #{item.content_details.related_playlists.uploads}"
        upload_channel = item.content_details.related_playlists.uploads
      end

      upload_channel
    end

    def get_video_ids(playlist_id)
      puts 'Playlist items:'

      video_ids = []
      next_page_token = nil
      loop do
        items = list_playlist_items(playlist_id, page_token: next_page_token, max_results: 50)
        next_page_token = items.next_page_token

        items.items.each do |item|
          puts "# #{item.id}"
          if item.content_details
            puts "- video id: #{item.content_details.video_id}"
            video_ids << item.content_details.video_id
          else
            puts 'not a video?!'
          end
        end

        break unless items.next_page_token
      end

      video_ids
    end

    def has_caption?(video_id, lang: 'en', trackKind: 'standard')
      captions = get_captions(video_id)

      captions.items.each do |item|
        if item.snippet.track_kind == trackKind && item.snippet.language == lang
          return true
        end
      end

      return false
    end

    private
      def list_channels(username)
        @youtube.list_channels('contentDetails', max_results: 1, for_username: username)
      end

      def list_playlist_items(playlist_id, page_token: nil, max_results: nil)
        @youtube.list_playlist_items('snippet,contentDetails', playlist_id: playlist_id, page_token: page_token, max_results: max_results)
      end

    def get_captions(video_id)
      @youtube.list_captions('snippet', video_id)
    end
  end
end