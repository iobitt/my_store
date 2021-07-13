class ApplicationController < ActionController::Base

  def render_403
    render file: "public/403.html", status: 403
  end

  def render_404
    render file: "public/404.html", status: 404
  end

  private

  def check_auth
    get_user

    unless @user
      render_403
    end
  end

  def get_user
    if params["external_token"]
      @user = Manager.find_by_external_token(params["external_token"])
    elsif session[:user_id]
      @user = Manager.find_by_id(session[:user_id])
    end
  end

end
