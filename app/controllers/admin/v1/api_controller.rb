module Admin
  module V1
    class ApiController < ApplicationController
      include Authenticable

      def render_errors(message: nil, fields: nil, status: :unprocessable_entity)
        errors = {}
        errors['fields'] = fields if fields.present?
        errors['message'] = message if message.present?
        render json: { errors: errors }, status: status
      end
    end
  end
end
