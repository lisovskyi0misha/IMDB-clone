RSpec.shared_examples 'renders layout for admin' do
  it 'renders admin layout template' do
    subject
    expect(response).to render_template(layout: 'layouts/admin_application')
  end
end

RSpec.shared_examples 'non-admin responses' do
  it 'redirects to root page' do
    subject
    expect(response).to redirect_to root_path
  end

  it 'flashes error message' do
    subject
    expect(flash.alert).to eq('You don\'t have rights to access this page')
  end
end
