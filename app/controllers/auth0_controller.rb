class Auth0Controller < ApplicationController
  def callback
    auth_info = request.env['omniauth.auth']
    session[:userinfo] = auth_info['extra']['raw_info']

    # Redirect to the URL you want after successful auth
    # redirect_to root_path
    redirect_to '/dashboard'
  end

  def failure
    @error_msg = request.params['message']
  end

  def logout
  end
end
