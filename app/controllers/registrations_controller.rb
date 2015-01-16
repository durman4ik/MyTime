class RegistrationsController < Devise::RegistrationsController

  respond_to :json, :html

  def create
    respond_to do |format|
      format.html { super }
      format.json do

        user = User.new(user_params)

          if user.save
            render :json=> { :auth_token => user.authentication_token, :email => user.email }, :status=>201
            return
          else
            warden.custom_failure!
            render :json=> user.errors, :status=>422
          end
      end
    end
  end

  protected
  def user_params
    params.require(:user).permit(:email, :password)
  end
end