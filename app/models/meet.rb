# Meet - one record for each meet.
class Meet < ActiveRecord::Base
  mount_uploader :input_file, ExtractUploader
end
