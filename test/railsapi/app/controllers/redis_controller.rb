class RedisController < ApplicationController
  def index
    render json: $redis.ping == "PONG"
  end
end
