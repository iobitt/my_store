class ProductsController < ApplicationController

  before_action :get_user
  before_action :check_auth, only: [:create, :new, :edit, :update, :destroy]
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all.order updated_at: :desc
  end

  def show
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

    def check_auth
      unless @user
        render_403
      end
    end
end
