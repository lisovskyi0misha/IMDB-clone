require 'rails_helper'
require_relative '../shared_examples/get_responses'
require_relative '../shared_examples/non_get_responses'
require_relative '../shared_examples/common_controller_behavior'
require_relative '../shared_examples/common_admin_controller_behavior'

RSpec.describe Admin::MoviesController do
  describe 'GET #index' do
    subject(:index_request) { get '/admin/movies' }
    let(:movies) { create_list(:movie, 3) }

    context 'with non-authenticated user' do
      include_examples 'non-authenticated user'
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'when admin' do
        let(:user) { create(:user, :admin) }

        include_examples 'positive GET responses', :index
        include_examples 'renders layout for admin'

        it 'finds movies' do
          movies
          index_request
          expect(assigns(:movies)).to eq(movies)
        end
      end

      context 'when regular user' do
        let(:user) { create(:user) }

        include_examples 'non-admin responses'
      end
    end
  end

  describe 'GET #show' do
    subject(:show_request) { get "/admin/movies/#{movie.id}" }
    let(:movie) { create(:movie) }

    context 'with non-authenticated user' do
      include_examples 'non-authenticated user'
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'when admin' do
        let(:user) { create(:user, :admin) }

        include_examples 'finds movie'
        include_examples 'positive GET responses', :show
        include_examples 'renders layout for admin'
      end

      context 'when regular user' do
        let(:user) { create(:user) }

        include_examples 'non-admin responses'
      end
    end
  end

  describe 'GET #new' do
    subject(:new_request) { get '/admin/movies/new' }

    context 'with non-authenticated user' do
      include_examples 'non-authenticated user'
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'when admin' do
        let(:user) { create(:user, :admin) }

        include_examples 'positive GET responses', :new
        include_examples 'renders layout for admin'

        it 'builds new movie' do
          new_request
          expect(assigns(:movie)).to be_a_new(Movie)
        end
      end

      context 'when regular user' do
        let(:user) { create(:user) }

        include_examples 'non-admin responses'
      end
    end
  end

  describe 'POST #create' do
    subject(:create_request) { post '/admin/movies', params: }

    context 'with non-authenticated user' do
      let(:params) { { movie: attributes_for(:movie) } }

      include_examples 'non-authenticated user'
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'when admin' do
        let(:user) { create(:user, :admin) }

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

      context 'when regular user' do
        let(:user) { create(:user) }
        let(:params) { { movie: attributes_for(:movie) } }

        include_examples 'non-admin responses'
      end
    end
  end

  describe 'GET #edit' do
    subject(:edit_request) { get "/admin/movies/#{movie.id}/edit" }
    let(:movie) { create(:movie) }

    context 'with non-authenticated user' do
      include_examples 'non-authenticated user'
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'when admin' do
        let(:user) { create(:user, :admin) }

        include_examples 'finds movie'
        include_examples 'positive GET responses', :edit
      end

      context 'when regular user' do
        let(:user) { create(:user) }

        include_examples 'non-admin responses'
      end
    end
  end

  describe 'PATCH #update' do
    subject(:update_request) { patch "/admin/movies/#{movie.id}", params: }
    let(:movie) { create(:movie) }

    context 'with non-authenticated user' do
      let(:params) { { movie: { title: 'Updated title' } } }

      include_examples 'non-authenticated user'
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'when admin' do
        let(:user) { create(:user, :admin) }

        context 'with valid params' do
          let(:params) { { movie: { title: 'Updated title' } } }
          let(:shared_params) { { path: movie_path(movie), message_part: 'updated' } }

          include_examples 'finds movie'
          include_examples 'positive non-GET responses', 'show'

          it 'updates movie' do
            update_request
            expect(Movie.find_by_id(movie.id).title).to eq('Updated title')
          end
        end

        context 'with invalid params' do
          let(:params) { { movie: { title: nil, text: nil, category: nil } } }

          it 'does not update movie' do
            update_request
            expect(Movie.find_by_id(movie.id).title).not_to eq('Updated title')
          end

          include_examples 'finds movie'
          include_examples 'negative non-GET responses', :edit, :admin_application
        end
      end

      context 'when regular user' do
        let(:user) { create(:user) }
        let(:params) { { movie: { title: 'Updated title' } } }

        include_examples 'non-admin responses'
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:destroy_request) { delete "/admin/movies/#{movie.id}" }
    let(:movie) { create(:movie) }
    let(:shared_params) { { path: root_path, message_part: 'deleted' } }

    context 'with non-authenticated user' do
      include_examples 'non-authenticated user'
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'when admin' do
        let(:user) { create(:user, :admin) }

        it 'deletes movie from database' do
          movie
          expect { destroy_request }.to change(Movie, :count).by(-1)
        end

        include_examples 'finds movie'
        include_examples 'positive non-GET responses', :index
      end

      context 'when regular user' do
        let(:user) { create(:user) }

        include_examples 'non-admin responses'
      end
    end
  end
end
