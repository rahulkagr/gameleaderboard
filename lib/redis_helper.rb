class RedisHelper
  # expect keys to be an array of strings
  def self.flush_cache(keys)
    puts "Flushing cache for keys: #{keys}"
    $redis.del(*keys)
  end
end
