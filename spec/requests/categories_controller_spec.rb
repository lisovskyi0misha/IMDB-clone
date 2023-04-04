require 'rails_helper'
require_relative 'shared_examples/get_responses'

RSpec.describe CategoriesController do
  describe 'GET #index' do
    subject(:index_request) { get "/movies/categories/#{categories}" }

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
  end
end
