require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :badges do
   desc "correct badge season"
   task seasons: :environment do
      Badge.all.each do | b |
         puts b.created_at
         b.season = get_season_by_date(b.created_at)
         b.save 
         puts b.season
      end   
   end
end
 