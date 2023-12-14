class Api::V1::ArticlesController < ApplicationController

  def index
    articles = Article.all
    render json: { articles: articles }, status: :ok
  end

  def show
    article = Article.find_by(id: params[:id]) 
  
    if article
      render json: article, status: 200
    else
      render json: { error: "Article not found" }, status: :not_found
    end
  end

  def create
    article = Article.new(article_params)
    if article.save
      render json: { message: "Article created successfully!", article: article }, status: :created
    else
      render json: { error: "Error creating article", errors: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
      article = Article.find_by(id: params[:id])

      if article 
        if article.update(article_params)
          render json: { message: "Article updated successfully!", article: article }, status: :ok
        else
          render json: { error: "Error updating article", errors: (model_name).errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Article not found" }, status: :not_found
      end
  end

  def destroy
    article = Article.find_by(id: params[:id])

    if article 
      article.destroy
      render json: { message: "Article  deleted successfully" }, status: :ok
    else
      render json: { error: "Article not found" }, status: :not_found
    end
  end

  # private methods
  private
  def article_params
      params.require(:article).permit(:title, :subtitle, :article_img, :body, :author)
  end

  def search_articles
    articles = Article.all
  
    articles = articles.where("title LIKE ?", "%#{params[:title]}%") if params[:title].present?
    articles = articles.where("author LIKE ?", "%#{params[:author]}%") if params[:author].present?
    articles = articles.where(id: params[:id]) if params[:id].present?

  end
end
