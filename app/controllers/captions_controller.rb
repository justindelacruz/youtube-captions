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
    @captions = []

    api_key = 'AIzaSyALJLTKm7i61cq6SklsAqcfoo5oEn2m9q0'
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
  def caption_params
    params.require(:caption).permit(:text, :start_time, :end_time)
  end
end
