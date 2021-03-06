class AccountsController < ApplicationController
  before_action :authenticate_account!
  before_filter :verify_account!
  skip_before_filter :verify_authenticity_token, :only => [:setting_update, :setting_ip_create, :setting_ip_delete]

  def index
    @account = current_account

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @account = current_account

    respond_to do |format|
      format.html { redirect_to account_index_path(current_account.name) }
      format.json
    end
  end

  def setting
    @account = current_account
    respond_to do |format|
      format.html
      format.json
    end
  end

  def setting_update
    current_account.update(name: params[:name], email: params[:email]) unless params[:name].nil?
    render json: :success
  end

  def setting_ip_create
    unless params[:ip].nil?
      Account.find(current_account.id).servers.create(ip_address: params[:ip])
      EasyWorker.perform_async Server.last.id
    end
    render json: :success
  end

  def setting_ip_delete
    Account.find(current_account.id).servers.where(ip_address: params[:ip]).destroy_all unless params[:ip].nil?
    render json: :success
  end
end
