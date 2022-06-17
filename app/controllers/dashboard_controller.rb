class DashboardController < ApplicationController
  def show
    @userinfo = session[:userinfo]
  end
end
