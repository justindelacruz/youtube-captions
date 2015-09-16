class CaptionsController < ApplicationController
  def index
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.find(params[:episode_id])
    @captions = @episode.captions.order(:start_time).all
  end

  def show
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.find(params[:episode_id])
    @captions = @episode.captions.find(params[:id])
  end

  def new
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.find(params[:episode_id])
    @caption = Caption.new
  end

  def edit
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.find(params[:episode_id])
  end

  def create
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.find(params[:episode_id])
    @caption = @episode.captions.create(caption_params)

    if @caption.save
      redirect_to [@source, @channel, @episode, @caption]
    else
      render 'new'
    end
  end

  def update
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.find(params[:episode_id])
    @caption = @episode.captions.find(params[:id])

    if @caption.update(caption_params)
      redirect_to [@source, @channel, @episode, @caption]
    else
      render 'edit'
    end
  end

  def destroy
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.find(params[:episode_id])
    @caption = @episode.captions.find(params[:id])
    @caption.destroy

    redirect_to source_channel_episode_captions_path(@source, @channel)
  end

  private
  def caption_params
    params.require(:caption).permit(:text, :start_time, :end_time)
  end
end
