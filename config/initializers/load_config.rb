config=YAML::load(ERB.new(File.read(Rails.root.join("config","config.yml"))).result)
CONFIG = config[Rails.env]
