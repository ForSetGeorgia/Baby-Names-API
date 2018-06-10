class V1::YearsController < ApplicationController

  # GET /years
  def index
    json_response(Year.unique)
  end

end
