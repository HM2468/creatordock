class ContentsController < ApplicationController
  before_action :set_creator

  def new
    @content = @creator.contents.build
  end

  def create
    result = Contents::Create.call(@creator, content_params)
    if result.success?
      redirect_to creator_path(@creator), notice: "Content was successfully created."
    else
      @content = result.content
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @content = @creator.contents.find(params[:id])
  end

  def update
    @content = @creator.contents.find(params[:id])
    if @content.update(content_params)
      redirect_to creator_path(@creator), notice: "Content was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_creator
    @creator = Creator.find(params[:creator_id])
  end

  def content_params
    params.require(:content).permit(:title, :social_media_url, :social_media_provider)
  end
end
