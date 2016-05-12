class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create, :bad_routei]

  def new
    @new_user = User.new
  end

  def create
    @new_user = User.new(user_create_params[:user])

    if @new_user.save
      redirect_to new_session_path
    else
      render :new
    end
  end

  # def create
  #   merchant = Merchant.find_by_userName(params[:userName])

  #   if merchant && merchant.authenticate(params[:password])
  #       merchant_session[:merchant_id] = merchant.id
  #       redirect_to root_url, :notice => "Merchanthas been logged in"
  #   else
  #       flash.now[:error] = "Invalid username or password."
  #       @title  = "Merchant Signin"
  #       render "new"
  #   end
  # end

  def show_merchant
    @merchant_order_items = OrderItem.joins(:product).where("products.user_id": params[:id])
    @total_revenue = OrderItem.joins(:product).where("products.user_id": params[:id]).sum("products.price_in_dollars")

    # merchant_products = Product.where(user_id: params[:id])
    # product_id_array = []
    # merchant_products.each do |product|
    #   product_id_array << product.id
    # end
    # orderitems = OrderItem.all
    # # need an empty active record relation? 
    # @merchant_order_items = []

    # orderitems.each do |item|
    #   if product_id_array.include? item.product_id
    #     @merchant_order_items << item
    #   end
    # end
  end

    def show
      @merchant = User.find(params[:id])
      @products = Product.where(user_id: @merchant.id)
      @category ||= Category.new
      @categories = Category.all
      @product = Product.new

      render "users/merchant"
    end



  private

  def require_login
    unless current_user && current_user.id == params[:id].to_i
      render :bad_route
    end
  end

  def user_create_params
    params.permit(user: [:user_name, :email, :password, :password_confirmation])
  end
end
