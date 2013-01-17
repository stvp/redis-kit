class RedisController < ApplicationController
  def ping
    render json: $redis.ping == "PONG"
  end
end
