class V1::NamesController < ApplicationController

  before_action :set_name, only: [:show]

  # GET /names/:id
  def show
    json_response(NameSerializer.new(@name).serialized_json)
  end

  # GET /names/search
  def search
    params[:limit] ||= 20
    @names = Name.search(params[:q]).limit(params[:limit])
    json_response(NameSerializer.new(@names).serialized_json)
  end

  private

  def name_params
    # whitelist params
    params.permit(:name_ka, :name_en, :gender)
  end

  def set_name
    @name = Name.friendly.find(params[:id])
  end
end
