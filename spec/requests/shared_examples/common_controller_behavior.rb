RSpec.shared_examples 'finds movie' do
  it 'finds movie' do
    subject
    expect(assigns(:movie)).to eq(movie)
  end
end
