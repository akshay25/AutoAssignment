class AllocationController < ApplicationController

  skip_before_action :verify_authenticity_token, :only => [:index]

  def index
    if params[:orders].blank? || params[:DEs].blank?
      render json: {message: "missing data"}, status: 400
      return
    end
    result = Allocator.new.allocate(params[:orders], params[:DEs])
    render json: result, status: 200
  end

end
