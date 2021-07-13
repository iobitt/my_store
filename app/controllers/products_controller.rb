require 'date'


class ProductsController < ApplicationController

  before_action :get_user
  before_action :check_auth
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    updated_after = params['updated_after']

    if updated_after.nil?
      @products = Product.all.order updated_at: :desc
    else
      @products = Product.where(["updated_at > ?", DateTime.strptime(updated_after,'%s')])
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user = @user

    if @product.save
      redirect_to @product
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @product.update!(product_params)

    if @product.save
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to action: :index
  end

  private

    def find_product
      @product = Product.where(id: params[:id]).first
      render_404 unless @product
    end

    def product_params
      params.require(:product).permit(:name, :price, :quantity)
    end

    def get_user
      if session[:user_id]
        @user = Manager.find_by_id(session[:user_id])
      end
    end

end
