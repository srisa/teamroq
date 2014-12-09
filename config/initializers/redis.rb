
REDIS_CONFIG = YAML.load( File.open( Rails.root.join("config/redis.yml") ) ).symbolize_keys
dflt = REDIS_CONFIG[:default].symbolize_keys
cnfg = dflt.merge(REDIS_CONFIG[Rails.env.to_sym].symbolize_keys) if REDIS_CONFIG[Rails.env.to_sym]


if Rails.env == "test"
	$redis = MockRedis.new 
else
	$redis = Redis.new(cnfg)
end	

#Resque redis config
Resque.redis = $redis