class SourcesController < ApplicationController
  def index
    @sources = Source.all
  end

  def show
    @source = Source.find(params[:id])
  end

  def new
    @source = Source.new
  end

  def edit
    @source = Source.find(params[:id])
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
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    redirect_to sources_path
  end

  private
    def source_params
      params.require(:source).permit(:name, :slug, :image)
    end
end
