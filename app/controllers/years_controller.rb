class YearsController < ApplicationController
  before_action :set_name
  before_action :set_name_year, only: [:show]

  # GET /names/:name_id/years
  def index
    json_response(@name.years)
  end

  # GET /names/:name_id/years/:id
  def show
    json_response(@year)
  end

  private

  def year_params
    params.permit(:year, :name_id)
  end

  def set_name
    @name = Name.find(params[:name_id])
  end

  def set_name_year
    @year = @name.years.find_by!(id: params[:id]) if @name
  end
end