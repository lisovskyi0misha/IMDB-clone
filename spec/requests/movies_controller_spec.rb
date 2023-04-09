require 'rails_helper'
require_relative 'shared_examples/get_responses'
require_relative 'shared_examples/non_get_responses'
require_relative 'shared_examples/common_controller_behavior'

RSpec.describe MoviesController do
  describe 'GET #index' do
    subject(:index_request) { get '/' }

    include_examples 'positive GET responses', :index
  end

  describe 'GET #show' do
    subject(:show_request) { get "/movies/#{movie.id}" }
    let(:movie) { create(:movie) }

    describe 'finding rating' do
      let(:user) { create(:user) }

      context 'with rating' do
        let(:rating) { create(:rating, rated_movie: movie, rated_user: user) }

        context 'with non-authenticated user' do
          it 'does not find rating' do
            rating
            show_request
            expect(assigns(:rating)).to eq(nil)
          end
        end

        context 'with non-authenticated user' do
          before { sign_in user }

          it 'does not find rating' do
            rating
            show_request
            expect(assigns(:rating)).to eq(rating)
          end
        end
      end

      context 'without rating' do
        let(:rating) { nil }

        context 'with non-authenticated user' do
          it 'does not find rating' do
            rating
            show_request
            expect(assigns(:rating)).to eq(nil)
          end
        end

        context 'with non-authenticated user' do
          before { sign_in user }

          it 'does not find rating' do
            rating
            show_request
            expect(assigns(:rating)).to eq(nil)
          end
        end
      end
    end

    include_examples 'finds movie'
    include_examples 'positive GET responses', :show
  end
end
