class Api::V1::ComicsController < ApplicationController
  def index
    comics = Comic.all
    render json: {comics: comics}
  end
end
