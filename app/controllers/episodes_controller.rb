class EpisodesController < ApplicationController
  def index
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episodes = @channel.episodes.all
  end

  def show
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.find(params[:id])
  end

  def new
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = Episode.new
  end

  def edit
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.find(params[:id])
  end

  def create
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.create(episode_params)

    if @episode.save
      redirect_to [@source, @channel, @episode]
    else
      render 'new'
    end
  end

  def update
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.find(params[:id])

    if @episode.update(episode_params)
      redirect_to [@source, @channel, @episode]
    else
      render 'edit'
    end
  end

  def destroy
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:channel_id])
    @episode = @channel.episodes.find(params[:id])
    @episode.destroy

    redirect_to source_channel_episodes_path(@source, @channel)
  end

  private
    def episode_params
      params.require(:episode).permit(:name, :slug, :image, :date_created, :description)
    end
end
