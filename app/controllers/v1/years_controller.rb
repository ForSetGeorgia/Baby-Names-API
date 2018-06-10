class V1::YearsController < ApplicationController

  # GET /years
  def index
    render json: Year.unique
  end

end
