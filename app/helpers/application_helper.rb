# Base application helpers
module ApplicationHelper

  # calculate hamonic mean for list of values
  def get_harmonic_mean(score_list)
    return 0 if score_list.size == 0
    sum = 0
    score_list.each  do | score |
      sum += (1.0/score)
    end
    mean = score_list.size / sum
  end

  # Convert 00:00:00 to float min
  def get_float_time(time)
    if time
      if time.scan(/(?=:)/).count == 2
        hh, mm, ss = time.split(':')
      else
        hh = 0
        mm, ss = time.split(':')
      end
      return (hh.to_i * 60) + mm.to_i + (ss.to_i / 60.0)
    else
      return 0
    end
  end

  def get_seasons_list
    # Orienteering season runs from September to May
    end_year = (Date.today + 6.months).year - 2000
    start_year = end_year - 1
    ["#{start_year}/#{end_year}", "#{start_year-1}/#{end_year-1}"]
  end

  def get_season_by_date(time)
    end_year = (time + 6.months).year - 2000
    start_year = end_year - 1
    "#{start_year}/#{end_year}"
  end

end
