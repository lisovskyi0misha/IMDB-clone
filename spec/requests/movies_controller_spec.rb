require 'rails_helper'
require_relative 'shared_examples/get_responses'
require_relative 'shared_examples/non_get_responses'
require_relative 'shared_examples/common_controller_behavior'

RSpec.describe MoviesController do
  describe 'GET #index' do
    subject(:index_request) { get '/' }
    let(:movies) { create_list(:movie, 3) }

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

  describe 'GET #new' do
    subject(:new_request) { get '/movies/new' }

    include_examples 'positive GET responses', :new

    it 'creates new movie' do
      new_request
      expect(assigns(:movie)).to be_a_new(Movie)
    end
  end

  describe 'POST #create' do
    subject(:create_request) { post '/movies', params: }

    context 'with valid params' do
      let(:params) { { movie: attributes_for(:movie) } }
      let(:shared_params) { { path: root_path, message_part: 'created' } }

      it 'saves movie to database' do
        expect { create_request }.to change(Movie, :count).by(1)
      end

      include_examples 'positive non-GET responses', 'index'
    end

    context 'with invalid params' do
      let(:params) { { movie: { title: nil, text: nil, category: nil } } }

      it 'does not save movie to database' do
        expect { create_request }.not_to change(Movie, :count)
      end

      include_examples 'negative non-GET responses', :new
    end

    describe 'adding image' do
      let(:params) { { movie: attributes_for(:movie, :with_image) } }

      it 'attaches image to movie' do
        create_request
        expect(Movie.first.image.blob.filename).to eq('test_image.png')
      end
    end

    describe 'attaching trailer' do
      let(:params) { { movie: attributes_for(:movie, :with_trailer) } }

      it 'attaches trailer to movie' do
        create_request
        expect(Movie.first.trailer.blob.filename).to eq('test_video.mp4')
      end
    end
  end

  describe 'GET #edit' do
    subject(:edit_request) { get "/movies/#{movie.id}/edit" }
    let(:movie) { create(:movie) }

    include_examples 'finds movie'
    include_examples 'positive GET responses', :edit
  end

  describe 'PATCH #update' do
    subject(:update_request) { patch "/movies/#{movie.id}", params: }
    let(:movie) { create(:movie) }

    before { update_request }

    context 'with valid params' do
      let(:params) { { movie: { title: 'Updated title' } } }
      let(:shared_params) { { path: movie_path(movie), message_part: 'updated' } }

      include_examples 'finds movie'
      include_examples 'positive non-GET responses', 'show'

      it 'updates movie' do
        expect(Movie.find_by_id(movie.id).title).to eq('Updated title')
      end
    end

    context 'with invalid params' do
      let(:params) { { movie: { title: nil, text: nil, category: nil } } }

      it 'does not update movie' do
        expect(Movie.find_by_id(movie.id).title).not_to eq('Updated title')
      end

      include_examples 'finds movie'
      include_examples 'negative non-GET responses', :edit
    end
  end

  describe 'DELETE #destroy' do
    subject(:destroy_request) { delete "/movies/#{movie.id}" }
    let(:movie) { create(:movie) }
    let(:shared_params) { { path: root_path, message_part: 'deleted' } }

    it 'deletes movie from database' do
      movie
      expect { destroy_request }.to change(Movie, :count).by(-1)
    end

    include_examples 'finds movie'
    include_examples 'positive non-GET responses', 'index'
  end
end
