APP_CONFIG = YAML.load(ERB.new(File.read("#{Rails.root}/config/config.yml")).result)[Rails.env]
APP_CONFIG.symbolize_keys!
BUILD = `git rev-parse --short HEAD`
APP_VERSION = '2.0.beta'
COURSES = ['Red', 'Green', 'Brown', 'Orange', 'Yellow', 'Sprint'].freeze
FINAL_SPLIT = 999
