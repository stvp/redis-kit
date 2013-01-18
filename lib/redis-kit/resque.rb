# Resque handles its own Redis connection, reconnecting after forks. If $redis
# is a separate connection, however, we'll disconnect it automatically after a
# fork so that the job can use the connection if it wants. If Resque is using
# the $redis connection, we let Resque handle it.
Resque.after_fork do |job|
  if $redis != Resque.redis.redis
    $redis.client.disconnect
  end
end
