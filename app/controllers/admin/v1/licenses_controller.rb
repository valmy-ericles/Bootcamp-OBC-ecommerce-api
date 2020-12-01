module Admin
  module V1
    class LicensesController < ApiController
      before_action :load_license, only: %i[update destroy]

      def index
        @licenses = License.all
      end

      def create
        @license = License.new
        @license.attributes = license_params
        save_license!
      end

      def update
        @license.attributes = license_params
        save_license!
      end

      def destroy
        @license.destroy!
      rescue StandardError
        render_errors(fields: @category.errors.messages)
      end

      private

      def load_license
        @license = License.find(params[:id])
      end

      def license_params
        return {} unless params.key?(:license)

        params.require(:license).permit(:key, :user_id, :game_id)
      end

      def save_license!
        @license.save!
        render :show
      rescue StandardError
        render_errors(fields: @license.errors.messages)
      end
    end
  end
end
