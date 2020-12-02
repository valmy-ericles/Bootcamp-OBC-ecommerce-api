module Admin
  module V1
    class SystemRequirementsController < ApiController
      before_action :load_system_requirement, only: %i[update destroy]

      def index
        @loading_service = Admin::ModelLoadingService.new(SystemRequirement.all, searchable_params)
        @loading_service.call
      end

      def create
        @system_requirement = SystemRequirement.new
        @system_requirement.attributes = system_requirement_params
        save_system_requirement!
      end

      def update
        @system_requirement.attributes = system_requirement_params
        save_system_requirement!
      end

      def destroy
        @system_requirement.destroy!
      rescue StandardError
        render_errors(fields: @system_requirement.errors.messages)
      end

      private

      def load_system_requirement
        @system_requirement = SystemRequirement.find(params[:id])
      end

      def searchable_params
        params.permit({ search: :name }, { order: {} }, :page, :length)
      end

      def system_requirement_params
        return {} unless params.key?(:system_requirement)

        params.require(:system_requirement).permit(
          :name, :operational_system, :storage,
          :processor, :memory, :video_board
        )
      end

      def save_system_requirement!
        @system_requirement.save!
        render :show
      rescue StandardError
        render_errors(fields: @system_requirement.errors.messages)
      end
    end
  end
end
