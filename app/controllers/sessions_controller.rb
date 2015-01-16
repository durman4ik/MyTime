class SessionsController < Devise::SessionsController

  skip_before_filter :authenticate_user!, :only => [:create, :new]
  skip_before_filter :verify_signed_out_user, only: [:destroy]
  prepend_before_filter :require_no_authentication, :only => [:create ]

  respond_to :json, :html

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  def create
    respond_to do |format|
      format.html {
        super
      }
      format.json do
        resource = resource_from_credentials

        return invalid_login_attempt unless resource

        if resource.valid_password?(request.env['HTTP_X_ANDROID_PASSWORD'])
          render :json => { user: { email: resource.email, :auth_token => resource.authentication_token } }, success: true, status: :created
        else
          invalid_login_attempt
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      format.html {
        super
      }
      format.json do

        user = User.find_for_database_authentication(:email => request.headers['HTTP_X_ANDROID_EMAIL'],
                                                     :authentication_token => request.headers['HTTP_X_ANDROID_TOKEN'])

        if user
          user.reset_authentication_token!
          render :json => { :message => 'Session deleted.' }, :success => true, :status => 204
        else
          render :json => { :message => 'Invalid token.' }, :status => 404
        end
      end
    end
  end

  protected
  def invalid_login_attempt
    warden.custom_failure!
    render json: { success: false, message: 'Error with your login or password' }, status: 401
  end

  def resource_from_credentials

    data = { email: request.env['HTTP_X_ANDROID_EMAIL'] }

    if res = resource_class.find_for_database_authentication(data)
      if res.valid_password?(request.env['HTTP_X_ANDROID_PASSWORD'])
        res
      end
    end
  end
end