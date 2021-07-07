require_relative '../services/account/is_auth'


class ProductsController < ApplicationController

  before_action :check_auth

  def index

  end

  private

  def check_auth
    @is_auth = Account::IsAuth.call(cookies[:token])
  end

end
