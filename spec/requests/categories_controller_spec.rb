require 'rails_helper'
require_relative 'shared_examples/get_responses'

RSpec.describe CategoriesController do
  describe 'GET #index' do
    context 'with direct request' do
      subject(:index_request) { get '/movies/categories/comedy', headers: { "Turbo-Frame" => false } }

      it 'redirects to root' do
        index_request
        expect(response).to redirect_to(root_path)
      end

      it 'responds with 302 status' do
        index_request
        expect(response).to have_http_status(:found)
      end
    end

    context 'with turbo frame request' do
      subject(:index_request) { get "/movies/categories/#{categories}", headers: { "Turbo-Frame" => true } }

      %i[action cartoon comedy].each do |genre|
        let!("#{genre}_movies".to_sym) { create_list(:movie, 2, genre) }
      end

      context 'with no categories' do
        let(:categories) { '' }

        include_examples 'positive GET responses', :index

        it 'finds all movies' do
          index_request
          expect(assigns(:movies)).to match_array(Movie.all)
        end
      end

      context 'with one category' do
        let(:categories) { 'comedy' }
        let!(:movies) { comedy_movies }

        include_examples 'positive GET responses', :index

        it 'finds movies with correct category' do
          index_request
          expect(assigns(:movies)).to eq(movies)
        end
      end

      context 'with more than one category' do
        let(:categories) { 'comedy-action-cartoon' }
        let!(:movies) { [comedy_movies, action_movies, cartoon_movies].flatten }

        include_examples 'positive GET responses', :index

        it 'finds movies with correct categories' do
          index_request
          expect(assigns(:movies)).to match_array(movies)
        end
      end

      context 'with one invalid category' do
        let(:categories) { 'invalid_category' }

        it 'redirects to root path' do
          index_request
          expect(response).to redirect_to(root_path)
        end

        it 'flashes alert mesage' do
          index_request
          expect(flash.alert).to eq('Invalid category')
        end
      end

      context 'with valid and invalid categories' do
        let(:categories) { 'invalid_category-comedy-another_invalid_category-action' }
        let!(:movies) { [comedy_movies, action_movies].flatten }

        include_examples 'positive GET responses', :index

        it 'finds movies with valid category' do
          index_request
          expect(assigns(:movies)).to match_array(movies)
        end
      end

      context 'with more that one invalid categories' do
        let(:categories) { 'invalid_category-another_invalid_category' }

        it 'redirects to root path' do
          index_request
          expect(response).to redirect_to(root_path)
        end

        it 'flashes alert mesage' do
          index_request
          expect(flash.alert).to eq('Invalid category')
        end
      end
    end
  end
end
