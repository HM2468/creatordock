class CreatorsController < ApplicationController
  def index
    @creators = Creator.all
    @creators = @creators.where("name ILIKE ?", "%#{Creator.sanitize_sql_like(params[:search])}%") if params[:search].present?
    @creators = @creators.order(:name).page(params[:page]).per(10)
  end

  def show
    @creator = Creator.find(params[:id])
    @contents = @creator.contents
    @contents = @contents.where(social_media_provider: params[:provider]) if params[:provider].present?
    @contents = @contents.order(created_at: :desc).page(params[:page]).per(10)
  end
end
