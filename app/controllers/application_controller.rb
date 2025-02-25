class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protect_from_forgery unless: -> { request.format.json? }

  around_action :exception_handling

  private

  def exception_handling
    begin
      yield
    rescue StandardError => e
      render_error(request, e, :bad_request)
    rescue ArgumentError => e
      render_error(request, e, :unprocessable_entity)
    rescue ActiveRecord::RecordNotFound => e
      render_error(request, e, :not_found)
    rescue => e
      render_error(request, e, :internal_server_error)
    end
  end

  def render_error(request, e, status)
    Rails.logger.error("Error renderer----> #{request.url} : #{e.message} #{e.backtrace.join("\n")}")
    status_code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    render json: ErrorHandler.new(status, status_code, e.message).to_json, status: status_code and return
  end
end
