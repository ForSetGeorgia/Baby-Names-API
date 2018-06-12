class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :set_default_limit
  before_action :set_locale

  def set_default_limit
    @default_limit = 10
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
