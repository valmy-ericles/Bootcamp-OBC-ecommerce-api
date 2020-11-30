module Admin
  module V1
    class UsersController < ApiController
      before_action :load_user, only: %i[show update destroy]

      def index
        scope_without_current_user = User.where.not(id: @current_user.id)
        @loading_service = Admin::ModelLoadingService.new(scope_without_current_user, searchable_params)
        @loading_service.call
      end

      def show; end

      def create
        @user = User.new
        @user.attributes = user_params
        save_user!
      end

      def update
        @user.attributes = user_params
        save_user!
      end

      def destroy
        @user.destroy!
      rescue StandardError
        render_errors(fields: @user.errors.messages)
      end

      private

      def searchable_params
        params.permit({ search: :name }, { order: {} }, :page, :length)
      end

      def load_user
        @user = User.find(params[:id])
      end

      def user_params
        return {} unless params.key?(:user)

        params.require(:user).permit(:id, :name, :email, :profile, :password, :password_confirmation)
      end

      def save_user!
        @user.save!
        render :show
      rescue StandardError
        render_errors(fields: @user.errors.messages)
      end
    end
  end
end
