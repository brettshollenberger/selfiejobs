class SelfiesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    render :text => "ok"
  end

  def create
    SelfieWorker.perform_async(params)
    render :text => "ok"
  end
end
