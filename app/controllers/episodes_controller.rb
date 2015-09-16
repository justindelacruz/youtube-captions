class EpisodesController < ApplicationController
  def index
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:channel_slug]
    @episodes = @channel.episodes.all
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
    @captions = []

    api_key = Rails.application.secrets.google_api_key
    username = 'vsauce'

    youtube_api = Youtube::Api.new(api_key: api_key)
    #upload_channel = youtube_api.get_upload_channel(username)
    #video_ids = youtube_api.get_video_ids(upload_channel)

    video_id = 'G7djoQfncRw'

    if youtube_api.has_caption?(video_id)
      youtube_captions = Youtube::Captions.new
      srt = youtube_captions.get_captions(video_id)
      file = SRT::File.parse(srt)
      file.lines.each do |line|

        caption = Caption.new(:text => line.text.join("\n"),
                              :start_time => line.start_time,
                              :end_time => line.end_time)

        @captions << line.text.join("\n")
        caption.save
      end

    else
      puts "#{video_id} does not have an english caption"
    end

    render :ingest
  end

  private
    def episode_params
      params.require(:episode).permit(:name, :slug, :image, :date_created, :description)
    end
end
