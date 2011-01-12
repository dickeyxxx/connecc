class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "narrow"

  def help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
  end
end
