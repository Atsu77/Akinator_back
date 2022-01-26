require 'rails_helper'

RSpec.describe 'Api::V1::Games', type: :request do
  let(:game) { Game.create!(status: 'in_progress') }

  describe 'GET /api/v1/games/:id/challenge' do
    it 'リクエストが成功すること' do
      get "/api/v1/games/#{game.id}/challenge"
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /api/v1/games/:id' do
    it 'パラメータがtrueの場合incorrectが返ってくること' do
      params = {
        correct: "true"
      }
      game = Game.create!(status: 'in_progress')
      put "/api/v1/games/#{game.id}", params: params
      expect(JSON.parse(response.body)["result"]).to eq('correct')
    end

    it 'パラメータがfalseの場合incorrectが返ってくること' do
      params = {
        correct: "false"
      }
      game = Game.create!(status: 'in_progress')
      put "/api/v1/games/#{game.id}", params: params
      expect(JSON.parse(response.body)["result"]).to eq('incorrect')
    end
  end
end
