class EpisodesController < ApplicationController
  def index
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episodes = @channel.episodes.order(date_created: :desc).all
  end

  def show
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.find_by slug: params[:slug]
  end

  def new
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = Episode.new
  end

  def edit
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.find_by slug: params[:slug]
  end

  def create
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.create(episode_params)

    if @episode.save
      redirect_to [@source, @channel, @episode]
    else
      render 'new'
    end
  end

  def update
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.find_by slug: params[:slug]

    if @episode.update(episode_params)
      redirect_to [@source, @channel, @episode]
    else
      render 'edit'
    end
  end

  def destroy
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episode = @channel.episodes.find_by slug: params[:slug]
    @episode.destroy

    redirect_to source_channel_episodes_path(@source, @channel)
  end

  def ingest
    source = Source.find_by slug: params[:source_slug]
    channel = source.channels.find_by slug: params[:channel_slug]

    username = params[:channel_slug]

    if source.slug == 'youtube'
      create_from_youtube username: username, channel: channel
      redirect_to source_channel_episodes_path(source, channel)
    else
      render plain: "No valid source found."
    end
  end

  private

    def create_from_youtube(username: username, channel: channel)
      api_key = Rails.application.secrets.google_api_key

      youtube_api = Youtube::Api.new(api_key: api_key)
      # An "upload channel" is the user's playlist that holds uploaded videos
      upload_channel_id = youtube_api.get_upload_channel_id(username)

      episodes = []
      youtube_api.get_episodes_from_playlist(upload_channel_id, max_results: 999) do |episode|
        episodes << Episode.new(slug: episode.snippet.resource_id.video_id,
                                name: episode.snippet.title,
                                description: episode.snippet.description,
                                image: episode.snippet.thumbnails.medium.url,
                                date_created: episode.snippet.published_at,
                                channel: channel)
      end
      Episode.import(episodes) # Uses activerecord-import
    end

    def episode_params
      params.require(:episode).permit(:name, :slug, :image, :date_created, :description)
    end
end
