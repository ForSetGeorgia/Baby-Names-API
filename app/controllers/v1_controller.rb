class V1Controller < ApplicationController

  # GET /v1/name
  # params: id
  def name
    render json: Year.name_details(params[:id]), each_serializer: YearNameSerializer
  end

  # GET /v1/search
  # - params: q, limit
  def search
    limit = params[:limit].nil? || params[:limit].to_i == 0 ? 20 : params[:limit].to_i
    @names = Year.name_search(params[:q]).limit(limit)
    render json: @names, each_serializer: YearNameSerializer
  end


  # GET /v1/years
  def years
    render json: Year.unique
  end


  # GET /v1/most_popular_for_year
  # - params: year, limit
  def most_popular_for_year
    limit = params[:limit].nil? || params[:limit].to_i == 0 ? 20 : params[:limit].to_i
    @names = Year.most_popular_for_year(params[:year], limit)
    render json: @names, each_serializer: YearNameSerializer
  end

  # GET /v1/most_popular_for_year_and_gender
  # - params: year, gender, limit
  def most_popular_for_year_and_gender
    limit = params[:limit].nil? || params[:limit].to_i == 0 ? 20 : params[:limit].to_i
    @names = Year.most_popular_for_year_and_gender(params[:year], params[:gender], limit)
    render json: @names, each_serializer: YearNameSerializer
  end

  # GET /v1/least_popular_for_year
  # - params: year, limit
  def least_popular_for_year
    limit = params[:limit].nil? || params[:limit].to_i == 0 ? 20 : params[:limit].to_i
    @names = Year.least_popular_for_year(params[:year], limit)
    render json: @names, each_serializer: YearNameSerializer
  end

  # GET /v1/least_popular_for_year_and_gender
  # - params: year, gender, limit
  def least_popular_for_year_and_gender
    limit = params[:limit].nil? || params[:limit].to_i == 0 ? 20 : params[:limit].to_i
    @names = Year.least_popular_for_year_and_gender(params[:year], params[:gender], limit)
    render json: @names, each_serializer: YearNameSerializer
  end


  # GET /v1/years_amount_summary
  def years_amount_summary
    render json: Year.years_amount_summary, each_serializer: YearsAmountSummarySerializer
  end

  # GET /v1/years_amount_summary
  def years_unique_names_summary
    render json: Year.years_unique_names_summary, each_serializer: YearsUniqueNamesSummarySerializer
  end


end
