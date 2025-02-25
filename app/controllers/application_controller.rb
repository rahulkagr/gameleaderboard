class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protect_from_forgery unless: -> { request.format.json? }

  before_action :authenticate_user
  before_action :rate_limit_user
  around_action :exception_handling

  attr_reader :current_user

  private

  def authenticate_user
    token = request.headers["auth-token"]
    @current_user = User.find_by(authtoken: token)
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def rate_limit_user
    return unless current_user

    key = "rate_limit:#{current_user.id}"
    last_request_time = $redis.get(key)

    if last_request_time && Time.now.to_f - last_request_time.to_f < 5
      render json: { error: "Too many requests. Please wait a few seconds." }, status: :too_many_requests
    else
      $redis.set(key, Time.now.to_f, ex: 5)
    end
  end

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
