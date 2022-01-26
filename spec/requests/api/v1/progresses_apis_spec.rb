require 'rails_helper'

RSpec.describe 'Api::V1::Progresses', type: :request do
  let(:game) { Game.create!(status: 'in_progress') }

  describe 'GET /api/v1/games/:game_id/progresses/new' do
    it 'リクエストが成功すること' do
      get "/api/v1/games/#{game.id}/progresses/new"
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /api/v1/games/:game_id/progresses' do
    it 'リクエストが成功すること' do
      params = {
        progress: {
          question_id: 1,
          answer: 'yes'
        }
      }
      post "/api/v1/games/#{game.id}/progresses", params: params
      expect(response).to have_http_status(302)
    end
  end
end
