class ApplicationController < ActionController::API
  rescue_from StandardError, with: :generic_error_response
  rescue_from Spotify::ApiError, with: :external_error_response

  private

  def generic_error_response(e)
    Rails.logger.error "Error: #{e.class}, message: #{e.message}, backtrace: #{e.backtrace}"
    render json: { error: "An unknown error has occurred: #{e.class}" }, status: 500
  end

  def external_error_response(e)
    Rails.logger.error "Error: #{e.class}, message: #{e.message}, backtrace: #{e.backtrace}"
    render json: { error: "An error response was received from an external upstream system: #{e.class}: #{e.message}" }, status: 502
  end
end