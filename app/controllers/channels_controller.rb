class ChannelsController < ApplicationController
  def index
    @source = Source.find_by slug: params[:source_slug]
    @channels = @source.channels.all
  end

  def show
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:slug]
  end

  def new
    @source = Source.find_by slug: params[:source_slug]
    @channel = Channel.new
  end

  def edit
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:slug]
  end

  def create
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.create(channel_params)

    if @channel.save
      redirect_to [@source, @channel]
    else
      render 'new'
    end
  end

  def update
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:slug]

    if @channel.update(channel_params)
      redirect_to [@source, @channel]
    else
      render 'edit'
    end
  end

  def destroy
    @source = Source.find_by slug: params[:source_slug]
    @channel = @source.channels.find_by slug: params[:slug]
    @channel.destroy

    redirect_to source_channels_path(@source)
  end

  private
    def channel_params
      params.require(:channel).permit(:slug, :name, :image)
    end
end
