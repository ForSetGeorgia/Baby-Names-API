class NamesController < ApplicationController

  before_action :set_name, only: [:show]

  # GET /names
  def index
    @names = Name.all
    json_response(@names)
  end

  # GET /names/:id
  def show
    json_response(@name)
  end

  private

  def name_params
    # whitelist params
    params.permit(:name_ka, :name_en, :gender)
  end

  def set_name
    @name = Name.find(params[:id])
  end
end
