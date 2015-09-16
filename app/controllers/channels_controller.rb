class ChannelsController < ApplicationController
  def index
    @source = Source.find(params[:source_id])
    @channels = @source.channels.all
  end

  def show
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:id])
  end

  def new
    @source = Source.find(params[:source_id])
    @channel = Channel.new
  end

  def edit
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:id])
  end

  def create
    @source = Source.find(params[:source_id])
    @channel = @source.channels.create(channel_params)

    if @channel.save
      redirect_to [@source, @channel]
    else
      render 'new'
    end
  end

  def update
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:id])

    if @channel.update(channel_params)
      redirect_to [@source, @channel]
    else
      render 'edit'
    end
  end

  def destroy
    @source = Source.find(params[:source_id])
    @channel = @source.channels.find(params[:id])
    @channel.destroy
    redirect_to source_channels_path(@source)
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
    def channel_params
      params.require(:channel).permit(:slug, :name, :image)
    end
end
