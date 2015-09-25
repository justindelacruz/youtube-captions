class CaptionsController < ApplicationController
  def index
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.find_by slug: params[:episode_slug]
    @captions = @episode.captions.order(:start_time).all
  end

  def show
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.find_by slug: params[:episode_slug]
    @caption = @episode.captions.find(params[:id])
  end

  def new
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.find_by slug: params[:episode_slug]
    @caption = Caption.new
  end

  def edit
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.find_by slug: params[:episode_slug]
    @caption = @episode.captions.find(params[:id])
  end

  def create
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.find_by slug: params[:episode_slug]
    @caption = @episode.captions.create(caption_params)

    if @caption.save
      redirect_to [@source, @channel, @episode, @caption]
    else
      render 'new'
    end
  end

  def update
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.find_by slug: params[:episode_slug]
    @caption = @episode.captions.find(params[:id])

    if @caption.update(caption_params)
      redirect_to [@source, @channel, @episode, @caption]
    else
      render 'edit'
    end
  end

  def destroy
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.find_by slug: params[:episode_slug]
    @caption = @episode.captions.find(params[:id])
    @caption.destroy

    redirect_to source_channel_episode_captions_path(@source, @channel)
  end

  def ingest
    source = Source.find_by slug: params[:source_slug]
    channel = source.channels.find_by slug: params[:channel_slug]
    episode = channel.episodes.find_by slug: params[:episode_slug]
    username = params[:channel_slug]

    if source.slug == 'youtube'
      create_from_youtube username: username, episode: episode, video_id: episode.slug
      redirect_to source_channel_episode_captions_path(source, channel, episode)
    else
      render plain: "No valid source found."
    end
  end

  private

    def create_from_youtube(username: username, episode: episode, video_id: video_id)
      api_key = Rails.application.secrets.google_api_key
      youtube_api = Youtube::Api.new(api_key: api_key)
      youtube_captions = Youtube::Captions.new

      if youtube_api.video_has_caption?(video_id)
        srt = youtube_captions.get_captions(video_id)
        captions = []
        SRT::File.parse(srt).lines.each do |line|
          captions << Caption.new(:text => line.text.join("\n"),
                                  :start_time => line.start_time,
                                  :end_time => line.end_time,
                                  :episode_id => episode.id)
        end
        Caption.import(captions)
      else
        puts "#{video_id} does not have an english caption"
      end
    end

    def caption_params
      params.require(:caption).permit(:text, :start_time, :end_time)
    end
end
