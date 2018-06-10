class V1::NamesController < ApplicationController

  # GET /names/:id
  def show
    render json: Name.with_years.friendly.find(params[:id]), serializer: NameYearsSerializer
  end

  # GET /names/search
  # - params: q, limit
  def search
    params[:limit] ||= 20
    @names = Name.search(params[:q]).limit(params[:limit]).with_most_recent_year
    render json: @names, each_serializer: NameYearsSerializer
  end

  # GET /names/most_popular
  # - params: year, limit
  def most_popular_for_year
    params[:limit] ||= 20
    @names = Year.most_popular_for_year(params[:year], params[:limit])
    render json: @names, each_serializer: YearNameSerializer
  end

  # GET /names/most_popular
  # - params: year, gender, limit
  def most_popular_for_year_and_gender
    params[:limit] ||= 20
    @names = Year.most_popular_for_year_and_gender(params[:year], params[:gender], params[:limit])
    render json: @names, each_serializer: YearNameSerializer
  end
end
