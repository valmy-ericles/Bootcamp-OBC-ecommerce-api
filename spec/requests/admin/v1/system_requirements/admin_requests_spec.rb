require 'rails_helper'

RSpec.describe 'Admin::V1::SystemRequirements as :admin', type: :request do
  let(:user) { create(:user) }

  context 'GET /system_requirements' do
    let(:url) { '/admin/v1/system_requirements' }
    let!(:system_requirements) { create_list(:system_requirement, 10) }

    context 'without any params' do
      it 'returns 10 system_requirements' do
        get url, headers: auth_header(user)
        expect(body_json['system_requirements'].count).to eq 10
      end

      it 'returns 10 first system_requirements' do
        get url, headers: auth_header(user)
        expected_system_requirements = system_requirements[0..9].as_json(only: %i[
                                                                           id
                                                                           name
                                                                           operational_system
                                                                           storage
                                                                           processor
                                                                           memory
                                                                           video_board
                                                                         ])
        expect(body_json['system_requirements']).to contain_exactly(*expected_system_requirements)
      end

      it 'returns success status' do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user) }
      end
    end

    context 'with pagination params' do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it 'returns records sized by :length' do
        get url, headers: auth_header(user), params: pagination_params
        expect(body_json['system_requirements'].count).to eq length
      end

      it 'returns system_requirements limited by pagination' do
        get url, headers: auth_header(user), params: pagination_params
        expected_system_requirements = system_requirements[5..9].as_json(only: %i[
                                                                           id
                                                                           name
                                                                           operational_system
                                                                           storage
                                                                           processor
                                                                           memory
                                                                           video_board
                                                                         ])
        expect(body_json['system_requirements']).to contain_exactly(*expected_system_requirements)
      end

      it 'returns success status' do
        get url, headers: auth_header(user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user) }
      end
    end
  end

  context 'POST /system_requirements' do
    let(:url) { '/admin/v1/system_requirements' }

    context 'With valid params' do
      let(:system_requirement_params) { { system_requirement: attributes_for(:system_requirement) }.to_json }

      it 'adds a new system requirement' do
        expect do
          post url, headers: auth_header(user), params: system_requirement_params
        end.to change(SystemRequirement, :count).by(1)
      end

      it 'returns last added system requirement' do
        post url, headers: auth_header(user), params: system_requirement_params
        expect_system_requirement = SystemRequirement.last.as_json(only: %i[
                                                                     id
                                                                     name
                                                                     operational_system
                                                                     storage
                                                                     processor
                                                                     memory
                                                                     video_board
                                                                   ])
        expect(body_json['system_requirement']).to eq expect_system_requirement
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: system_requirement_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'With invalid params' do
      let(:system_requirement_invalid_params) do
        { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json
      end

      it 'does not add a new system requirement' do
        expect do
          post url, headers: auth_header(user), params: system_requirement_invalid_params
        end.to_not change(SystemRequirement, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'PATCH /system_requirements/:id' do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    context 'with valid params' do
      let(:new_name) { 'My new system requirement' }
      let(:system_requirement_params) {
        { system_requirement: attributes_for(:system_requirement, name: new_name) }.to_json
      }

      it 'updates system requirement' do
        patch url, headers: auth_header(user), params: system_requirement_params
        system_requirement.reload
        expect(system_requirement.name).to eq new_name
      end

      it 'returns updated system requirement' do
        patch url, headers: auth_header(user), params: system_requirement_params
        system_requirement.reload
        expect_system_requirement = system_requirement.as_json(except: %i[created_at updated_at])
        expect(body_json['system_requirement']).to eq expect_system_requirement
      end

      it 'returns success status' do
        patch url, headers: auth_header(user), params: system_requirement_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:system_requirement_invalid_params) do
        { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json
      end

      it 'does not update SystemRequirement' do
        old_name = system_requirement.name
        patch url, headers: auth_header(user), params: system_requirement_invalid_params
        system_requirement.reload
        expect(system_requirement.name).to eq old_name
      end

      it 'returns error messages' do
        patch url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'DELETE /system_requirements/:id' do
    let!(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    it 'removes SystemRequirement' do
      expect do
        delete url, headers: auth_header(user)
      end.to change(SystemRequirement, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return no body content' do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end
  end
end
