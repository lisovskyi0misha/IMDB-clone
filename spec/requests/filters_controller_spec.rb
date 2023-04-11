require 'rails_helper'
require_relative 'shared_examples/get_responses'

RSpec.describe FiltersController do
  describe 'GET #index' do
    context 'with direct request' do
      subject(:index_request) { get '/movies/categories/comedy/page', headers: { "Turbo-Frame" => false } }

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
      subject(:index_request) { get "/movies/categories/#{categories}/page", headers: { "Turbo-Frame" => true } }

      %i[action cartoon comedy].each do |genre|
        let!("#{genre}_movies".to_sym) { create_list(:movie, 1, genre) }
      end

      context 'with no categories' do
        let(:categories) { '' }

        include_examples 'positive GET responses', :index

        it 'finds first 5 movies' do
          index_request
          expect(assigns(:movies)).to match_array(Movie.first(5))
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
          expect(assigns(:movies)).to match_array(movies.first(5))
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

    describe 'pagination' do
      subject(:index_request) { get "/movies/categories/comedy/page/#{page}", headers: { "Turbo-Frame" => true } }

      context 'without page' do
        let(:page) { nil }
        let!(:movies) { create_list(:movie, 2) }

        it 'finds first page movies' do
          index_request
          expect(assigns(:movies)).to eq(movies)
        end
      end

      context 'with first page' do
        let(:page) { 1 }
        let!(:movies) { create_list(:movie, 2) }

        it 'finds first page movies' do
          index_request
          expect(assigns(:movies)).to eq(movies)
        end
      end

      context 'with more than first page' do
        let(:page) { 2 }
        let!(:movies) { create_list(:movie, 6) }

        it 'finds first page movies' do
          index_request
          expect(assigns(:movies)).to match_array(movies.last)
        end
      end
    end
  end
end
