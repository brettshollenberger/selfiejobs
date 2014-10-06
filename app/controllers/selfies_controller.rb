class SelfiesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    render :text => "ok"
  end

  def create
    SelfieWorker.perform_async(message) unless message.nil?
    render :text => "ok"
  end

private
  def message
    params[:title]
  end
end
