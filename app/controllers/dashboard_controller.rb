class DashboardController < ApplicationController
  def index
    @total_creators = Creator.count
    @total_contents = Content.count
    @counts_by_provider = Content.group(:social_media_provider).count
  end
end
