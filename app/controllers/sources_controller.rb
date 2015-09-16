class SourcesController < ApplicationController
  def index
    @sources = Source.all
  end

  def show
    @source = Source.find_by slug: params[:slug]
  end

  def new
    @source = Source.new
  end

  def edit
    @source = Source.find_by slug: params[:slug]
  end

  def create
    @source = Source.new(source_params)

    if @source.save
      redirect_to @source
    else
      render 'new'
    end
  end

  def update
    @source = Source.find_by slug: params[:slug]

    if @source.update(source_params)
      redirect_to @source
    else
      render 'edit'
    end
  end

  def destroy
    @source = Source.find_by slug: params[:slug]
    @source.destroy

    redirect_to sources_path
  end

  private
    def source_params
      params.require(:source).permit(:name, :slug, :image)
    end
end
