class Api::V1::ProgressesController < ApplicationController
  def new
    current_game = Game.find(params[:game_id])
    question = Question.next_question(current_game)
    render json: { question: question }
  end

  def create
    current_game = Game.find(params[:game_id])

    # 回答した内容を保存
    progress = current_game.progresses.new(create_params)
    progress.assign_sequence
    progress.save!
    extract_comics = ExtractionAlgorithm.new(current_game).compute

    # 絞り込みの漫画数が1であればチャレンジ
    if extract_comics.count == 1
      redirect_to challenge_api_v1_game_path(current_game)
      return
    end

    # 絞り込みの漫画数が0であればギブアップ
    if extract_comics.count == 0
      render json: { giveup: 'giveup' }
      return
    end

    if extract_comics.count >= 2
      next_question = Question.next_question(current_game)
      if next_question.blank?
        current_game.status = 'finished'
        current_game.result = 'incorrect'
        current_game.save!

        render json: { giveup: 'giveup' }
        return
      end
      redirect_to new_api_v1_game_progresses_path(current_game)
    end
  end

  private

  def create_params
    params.require(:progress).permit(:question_id, :answer)
  end
end
