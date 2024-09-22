class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    begin
      @user = User.find(params[:id])
      redirect_to root_path, alert: "Access denied." unless @user == current_user
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Access denied."
    end
  end
end