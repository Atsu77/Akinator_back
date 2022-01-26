class Api::V1::GamesController < ApplicationController
  def new
    render json: { message: 'あなたが思った漫画を載せてみましょう!' }
  end

  def create
    game = Game.create!(status: 'in_progress')
    render json: { message: 'さあゲームを始めよう!', game_id: game.id }
  end

  def update
    current_game = Game.find(params[:id])

    current_game.status = 'finished'
    current_game.result = if params[:correct] == 'true'
                            :correct
                          else
                            :incorrect
                          end
    current_game.save!
    render json: { result: current_game.result }
  end

  def challenge
    current_game = Game.find(params[:id])
    extract_comics = ExtractionAlgorithm.new(current_game).compute
    comic = extract_comics.first
    render json: { comic: comic }
  end
end
