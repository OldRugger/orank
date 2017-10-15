class AnalyzeSplits
  include SuckerPunch::Job
  include ApplicationHelper
  
  def perform(meet_id)
    @meet_id = meet_id
    courses = SplitCourse.where(meet_id: meet_id).distinct.pluck(:course)
    courses.each do |course|
      Rails.logger.info("Analyze splits #{Meet.find(meet_id).name} - #{course}")
      process_course(course)
    end
  end
  
  private
  
  def process_course(course)
    @split_course = SplitCourse.where(meet_id: @meet_id, course: course).first
    return if @split_course == nil
    @split_course.save
    set_place_for_splits
    process_split_course(course)
  end
  
  def set_place_for_splits
    split_runners = SplitRunner.where(split_course_id: @split_course.id)
                      .where.not(start_punch: nil).all.pluck(:id)
    set_place_for_split_time(split_runners)
    set_place_for_current_split(split_runners)
  end
  
  def set_place_for_split_time(split_runners)
    @split_course.controls.times do |i|
      @splits = Split.where(split_runner_id: split_runners, control: i+1).order(:time)
      last_time = nil
      last_place = nil
      place = 1
      @splits.each do |s|
        if s.time == last_time
          s.split_place = last_place
        else
          s.split_place = place
        end
        place += 1
        last_time = s.time
        last_place = s.split_place
        s.save
      end
    end
    @splits = Split.where(split_runner_id: split_runners, control: FINAL_SPLIT).order(:time)
    last_time = nil
    last_place = nil
    place = 1
    @splits.each do |s|
      if s.time == last_time
        s.split_place = last_place
      else
        s.split_place = place
      end
      place += 1
      last_time = s.time
      last_place = s.split_place
      s.save
    end
  end
  
  def set_place_for_current_split(split_runners)
    @split_course.controls.times do |i|
      @splits = Split.where(split_runner_id: split_runners, control: i+1).order(:current_time)
      last_time = nil
      last_place = nil
      place = 1
      @splits.each do |s|
        if s.current_time == last_time
          s.current_place = last_place
        else
          s.current_place = place
        end
        place += 1
        last_time = s.current_time
        last_place = s.current_place
        s.save
      end
    end
  end
  
  def process_split_course(course)
    controls = @split_course.controls
    build_baselines(controls)
    calculate_split_results
  end
  
  def build_baselines(controls)
    control_splits = get_splits_by_control(controls)
    build_super_heroes(control_splits, controls)
  end

  def build_super_heroes(control_splits, controls)
    super_time = 0.0
    bat_time = 0.0
    superman = Runner.find_or_create_by(surname: 'Admin', firstname: 'Superman')
    super_runner = SplitRunner.find_or_create_by(split_course_id: @split_course.id, runner_id: superman.id)
    batman = Runner.find_or_create_by(surname: 'Admin', firstname: 'Batman')
    bat_runner = SplitRunner.find_or_create_by(split_course_id: @split_course.id, runner_id: batman.id)
    Split.where(split_runner_id: [super_runner.id, bat_runner.id]).destroy_all
    controls.times do |i|
      control = i+1
      super_time += control_splits[control][0]
      Split.create(split_runner_id: super_runner.id,
          control: control,
          current_time: super_time,
          time: control_splits[control][0])
          
      avg_time = get_harmonic_mean(control_splits[control])
      bat_time += avg_time
      Split.create(split_runner_id: bat_runner.id,
          control: control,
          current_time: bat_time,
          time: avg_time)
    end
    super_time += control_splits[FINAL_SPLIT][0]
    super_runner.total_time = super_time
    Split.create(split_runner_id: super_runner.id,
        control: FINAL_SPLIT,
        current_time: super_time,
        time: control_splits[FINAL_SPLIT][0])
        
    avg_time = get_harmonic_mean(control_splits[FINAL_SPLIT])
    bat_time += avg_time
    bat_runner.total_time = bat_time
    Split.create(split_runner_id: bat_runner.id,
        current_time: bat_time,
        control: FINAL_SPLIT,
        time: avg_time)
  end

  
  def get_splits_by_control(controls)
    control_splits = Hash.new
    splits = SplitRunner.joins(:splits)
                .select('splits.control, splits.time')
                  .where(split_course_id: @split_course.id)
                    .order('splits.control', 'splits.time')
    splits.each do |s|
      next if s.control > controls && s.control != FINAL_SPLIT
      if control_splits[s.control] == nil
        control_splits[s.control] = []
      end
      control_splits[s.control] << s.time
      
    end
    control_splits
  end
  
  def calculate_split_results
    batman = Runner.where(surname: 'Admin', firstname: 'Batman').first
    bat_runner = SplitRunner.where(runner_id: batman.id, split_course_id: @split_course.id).first
    batman_splits = Hash.new
    Split.where(split_runner_id: bat_runner).order(:control).each do |s|
      batman_splits[s.control] = s.time
    end
    runners = SplitRunner.where(split_course_id: @split_course.id).pluck(:id)
    runners.each do |id|
      process_runner_splits(id, batman_splits)
    end
  end
  
  def process_runner_splits(id, batman_splits)
    runner_splits = Split.where(split_runner_id: id).order(:control)
    speed = calculate_runner_speed(runner_splits, batman_splits)
    lost_time = update_time_gained_lost(runner_splits, batman_splits, speed)
    update_split_runner(id, speed, lost_time)
  end
  
  def update_split_runner(id, speed, lost_time)
    split_runner = SplitRunner.find(id)
    split_runner.lost_time = lost_time
    split_runner.speed = speed
    split_runner.save
  end
  
  def update_time_gained_lost(runner_splits, batman_splits, speed)
    total_time_lost = 0.0
    runner_splits.each do |s|
      if s.time && batman_splits[s.control]
        expected = batman_splits[s.control] / speed
        delta = expected - s.time
        if (-delta) > (s.time * 0.10)
          total_time_lost += delta
          s.lost_time = true
        end
        s.time_diff = delta
        s.save
      end
    end
    total_time_lost
  end
  
  def calculate_runner_speed(runner_splits, batman_splits)
    runner_scores = []
    runner_splits.each do |s|
      if s.time && batman_splits[s.control]
        performance = batman_splits[s.control] / s.time
        runner_scores << performance
      end
    end
    runners_speed = get_runners_speed(runner_scores)
  end
  
  def get_runners_speed(runner_scores)
    avg = get_harmonic_mean(runner_scores)
    low_boundary = avg - (avg*0.2)
    core_scores = [] # remove low outliers
    runner_scores.each do |s|
      if s > low_boundary
        core_scores << s
      end
    end
    get_harmonic_mean(core_scores)
  end

end
