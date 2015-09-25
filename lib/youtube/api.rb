require 'googleauth'
require 'google/apis/youtube_v3'

module Youtube
  class Api
    Youtube = Google::Apis::YoutubeV3

    def initialize(api_key: nil)
      @youtube = Youtube::YouTubeService.new
      @youtube.key = api_key || 'YOUR_API_KEY'
    end

    # Return the "uploads" channel for a given user.
    def get_upload_channel_id(username)
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

    # @param [Integer] max_results
    #    The maximum number of items that should be returned in the result set. Acceptable values are 0 to 50,
    #    inclusive. If not provided, it will use the YouTube API default value, which is 5.
    #
    # @yield [result] Parsed result if block supplied
    def get_episodes_from_playlist(playlist_id, max_results: nil)
      results_to_fetch = max_results
      next_page_token = nil
      loop do
        items = list_playlist_items(playlist_id, page_token: next_page_token, max_results: [results_to_fetch, 50].min)
        results_to_fetch -= items.items.length
        next_page_token = items.next_page_token

        items.items.each do |item|
          if item.snippet
            yield item
          end
        end

        break unless next_page_token and results_to_fetch > 0
      end if block_given?
    end

    # Return whether a video has captions defined.
    #
    # @param [String] video_id
    #    The YouTube video ID of the video for which the API should return caption tracks.
    # @param [String] lang
    #    The language of the caption track.
    # @param [String] trackKind
    #    Valid values:
    #        - ASR: A caption track generated using automatic speech recognition.
    #        - forced: A caption track that plays when no other track is selected in the player.
    #                  For example, a video that shows aliens speaking in an alien language might
    #                  have a forced caption track to only show subtitles for the alien language.
    #        - standard: A regular caption track. This is the default value.
    #
    # @return [Boolean]
    def video_has_caption?(video_id, lang: 'en', trackKind: 'standard')
      captions = get_captions(video_id)

      captions.items.each do |item|
        if item.snippet.track_kind == trackKind && item.snippet.language == lang
          return true
        end
      end

      false
    end

    private

      # Returns a collection of zero or more channel resources
      def list_channels(username)
        @youtube.list_channels('contentDetails', max_results: 1, for_username: username)
      end

      # Returns a collection of playlist items
      #
      # @param [String] playlist_id
      #    Unique ID of the playlist for which you want to retrieve playlist items.
      # @param [String] page_token
      #    A specific page in the result set that should be returned.
      # @param [Integer] max_results
      #    The maximum number of items that should be returned in the result set. Acceptable values are 0 to 50,
      #    inclusive. If not provided, it will use the YouTube API default value, which is 5.
      #
      # @yield [result, err] Result & error if block supplied
      #
      # @return [Google::Apis::YoutubeV3::ListPlaylistItemsResponse] Parsed result
      def list_playlist_items(playlist_id, page_token: nil, max_results: nil)
        @youtube.list_playlist_items('snippet,contentDetails', playlist_id: playlist_id, page_token: page_token, max_results: max_results)
      end

      # Returns a list of caption tracks that are associated with a specified video.
      def get_captions(video_id)
        @youtube.list_captions('snippet', video_id)
      end
  end
end