class CalculateResults
  include SuckerPunch::Job
  
  def perform(calc_run)
    # calc_results("Sprint")
    calc_results("Yellow")
    # calc_results("Orange")
    # calc_results("Green")
    # calc_results("Brown")
    # calc_results("Red")
  end
  
  private
  
  def calc_results(course)
    #Process course until average calculation delta drops below 0.5 or we exceed 15 passes
    init_globals
    delta = 99.5 # init delta to high value.
    pass  = 0
    while (delta > 0.5) do
      pass += 1
      delta = calc_race_gv(course, false) #false = don't updated database
      if (pass > 14)
        break
      end
    end
    # final run to update database
    calc_race_gv(course, true)
  end

  # initialize global calculation values
  def init_globals
    # clear cache
    @c_runner_gv = nil
    @c_runner_gv = LruRedux::Cache.new(2000)
    @course_time = nil
  end

  # calculate race / course garliness factor
  def calc_race_gv(course, update_db)
    total_delta = 0.0
    meet_cnt    = 0
    meets       = get_meets
    meets.each do |meet|
      meet_cnt += 1
      delta = process_course(meet,course)
      next if delta == nil
      # total_data += delta
      calc_runner_gv(course)
    end
    total_delta / meet_cnt
  end
  
  #calc run is based on meets for the last year
  def get_meets
    Meet.where("date > ?", Date.today - 1.year)
  end

  # process course results
  def process_course(meet,course)
    # skip any course with fewer that three runners
    return nil if Result.where(meet: meet.id, course: course).count < 3
    by_gender = get_course_by_gender(meet,course)
    genders   = by_gender ? ['F','M'] : ['A']
    genders.each do |gender|
      runer_times, score_list = process_course_results(meet.id,course,gender)
    end
  end
  
  # calculate runners garliness factor
  def calc_runner_gv(course)
    # binding.pry
  end

  # If there are three of each gender, calcs will be by gender.
  def get_course_by_gender(meet,course)
    Result.where(meet: meet.id, course: course, gender: 'F', classifier: '0').count >= 3 &&
    Result.where(meet: meet.id, course: course, gender: 'M', classifier: '0').count >= 3
  end
  
  def process_course_results(meet_id,course,gender)
    runner_entry = Struct.new(:runner_id, :runner_time)
    runner_times = []
    score_list   = []
    results = get_course_results(meet_id,course,gender)
    results.each do |result|
      # if valid result
      if result.classifier == 0
        runner_gv    = get_runner_gv(result,course,meet_id)
        score_list   << (result.float_time * runner_gv)
        runner_times << runner_entry.new(result.runner_id, result.float_time)
      end
    end
    return 0 if score_list.size < 3
    course_cgv = get_harmonic_mean(score_list)
    delta = update_meet_course_results(meet_id, results, course_cgv, course, runner_times)
  end
  
  # Update cource resutls based on course calculated garliness valaue
  def update_meet_course_results(meet_id, results, course_cgv, course, runner_times)
    runner_times.each do |runner|
      time = runner.runner_time
      runner_score = runner_score = course_cgv/time
      binding.pry
    end
  end
  
  # get meet/course resutls
  def get_course_results(meet_id,course,gender)
    if gender == 'A'
      results = Result.where(meet: meet_id, course: course, classifier: '0').order(:float_time)
    else
      results = Result.where(meet: meet_id, course: course, gender: gender, classifier: '0').order(:float_time)
    end
    @course_time = get_course_time(results) #need to cache this
    puts "#{meet_id} - #{course} - #{gender}: course time - #{@course_time}"
    results
  end
  
  # get runner's initial gnarliness value (GV)
  def get_runner_gv(result,course,meet_id)
    return get_initial_gv(result) if @c_runner_gv[result.runner_id].nil?
    @c_runner_gv[result.runner_id]
  end
  
  # runners initial GV is on the course time. Course time = 100,
  def get_initial_gv(result)
    gv = (@course_time / result.float_time) * 100
    @c_runner_gv[result.runner_id] = {cgv: gv, score: gv, races: 1}
    gv
  end
  
  # course time is based on the harmonic mean of the top three times for the course.
  def get_course_time(results)
    list = []
    results.take(3).each do |r|
      list << r.float_time
    end
    get_harmonic_mean(list)
  end
  
  # calculate hamonic mean for list of values
  def get_harmonic_mean(score_list)
    sum = 0
    score_list.each  do | score |
      sum += (1.0/score)
    end
    mean = score_list.size / sum
  end
end