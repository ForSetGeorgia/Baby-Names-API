class V1Controller < ApplicationController

  # GET /v1/name
  # params: id
  def name
    render json: Year.name_details(params[:id]), each_serializer: YearNameSerializer, :callback => params[:callback]
  end

  # GET /v1/search
  # - params: q, limit
  def search
    limit = set_limit
    @names = Year.name_search(params[:q]).paginate(per_page: limit, page: params[:page])
    render json: @names, each_serializer: YearNameSerializer, meta: meta_attributes(@names), :callback => params[:callback]
  end


  # GET /v1/years
  def years
    render json: Year.unique, :callback => params[:callback]
  end


  # GET /v1/most_popular_for_year
  # - params: year, limit
  def most_popular_for_year
    limit = set_limit
    @names = Year.most_popular_for_year(params[:year], limit)
    render json: @names, each_serializer: YearNameSerializer, :callback => params[:callback]
  end

  # GET /v1/most_popular_for_year_and_gender
  # - params: year, gender, limit
  def most_popular_for_year_and_gender
    limit = set_limit
    @names = Year.most_popular_for_year_and_gender(params[:year], params[:gender], limit)
    render json: @names, each_serializer: YearNameSerializer, :callback => params[:callback]
  end

  # GET /v1/least_popular_for_year
  # - params: year, limit
  def least_popular_for_year
    limit = set_limit
    @names = Year.least_popular_for_year(params[:year], limit)
    render json: @names, each_serializer: YearNameSerializer, :callback => params[:callback]
  end

  # GET /v1/least_popular_for_year_and_gender
  # - params: year, gender, limit
  def least_popular_for_year_and_gender
    limit = set_limit
    @names = Year.least_popular_for_year_and_gender(params[:year], params[:gender], limit)
    render json: @names, each_serializer: YearNameSerializer, :callback => params[:callback]
  end


  # GET /v1/largest_amount_increase_for_year
  # - params: year, limit
  def largest_amount_increase_for_year
    limit = set_limit
    @names = Year.largest_amount_increase_for_year(params[:year], limit)
    render json: @names, each_serializer: YearNameSerializer, :callback => params[:callback]
  end

  # GET /v1/largest_amount_increase_for_year_and_gender
  # - params: year, gender, limit
  def largest_amount_increase_for_year_and_gender
    limit = set_limit
    @names = Year.largest_amount_increase_for_year_and_gender(params[:year], params[:gender], limit)
    render json: @names, each_serializer: YearNameSerializer, :callback => params[:callback]
  end

  # GET /v1/largest_amount_decrease_for_year
  # - params: year, limit
  def largest_amount_decrease_for_year
    limit = set_limit
    @names = Year.largest_amount_decrease_for_year(params[:year], limit)
    render json: @names, each_serializer: YearNameSerializer, :callback => params[:callback]
  end

  # GET /v1/largest_amount_decrease_for_year_and_gender
  # - params: year, gender, limit
  def largest_amount_decrease_for_year_and_gender
    limit = set_limit
    @names = Year.largest_amount_decrease_for_year_and_gender(params[:year], params[:gender], limit)
    render json: @names, each_serializer: YearNameSerializer, :callback => params[:callback]
  end




  # GET /v1/years_amount_summary
  def years_amount_summary
    render json: Year.years_amount_summary, each_serializer: YearsAmountSummarySerializer, :callback => params[:callback]
  end

  # GET /v1/year_amount_summary
  # - params: year
  def year_amount_summary
    render json: Year.year_amount_summary(params[:year]), each_serializer: YearsAmountSummarySerializer, :callback => params[:callback]
  end

  # GET /v1/years_unique_names_summary
  def years_unique_names_summary
    render json: Year.years_unique_names_summary, each_serializer: YearsUniqueNamesSummarySerializer, :callback => params[:callback]
  end


  private

  def set_limit
    params[:limit].nil? || params[:limit].to_i == 0 ? @default_limit : params[:limit].to_i
  end

  def meta_attributes(collection, extra_meta = {})
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.previous_page,
      total_pages: collection.total_pages,
      total_count: collection.total_entries
    }.merge(extra_meta)
  end

end
