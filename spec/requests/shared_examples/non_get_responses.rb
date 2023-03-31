RSpec.shared_examples 'positive non-GET responses' do |template|
  it 'responds with status 302' do
    subject
    expect(response).to have_http_status(:found)
  end

  it "redirects to #{template}" do
    subject
    expect(response).to redirect_to(shared_params[:path])
  end

  it 'flashes success message' do
    subject
    expect(flash.notice).to eq("Movie was successfully #{shared_params[:message_part]}")
  end
end

RSpec.shared_examples 'negative non-GET responses' do |template|
  it 'responds with status 422' do
    subject
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "re-renders #{template}" do
    subject
    expect(response).to render_template(template)
  end

  it 'flashes error message' do
    subject
    expect(flash.alert).to eq('Title can\'t be blank, Text can\'t be blank, Category can\'t be blank')
  end
end
