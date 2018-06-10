class V1::NamesController < ApplicationController

  # GET /names/:id
  def show
    render json: Name.with_years.friendly.find(params[:id]), serializer: NameYearsSerializer
  end

  # GET /names/search
  def search
    params[:limit] ||= 20
    @names = Name.search(params[:q]).limit(params[:limit])
    render json: @names, each_serializer: NameSerializer
  end

end
