class AnalyzeSplits
  include SuckerPunch::Job
  include ApplicationHelper
  
  def perform(meet_id)
    @meet_id = meet_id
    COURSES.each do |course|
      Rails.logger.info("Analyze splits #{Meet.find(meet_id).name} - #{course}")
      process_course(course)
    end
  end
  
  private
  
  def process_course(course)
    @split_course = SplitCourse.where(meet_id: @meet_id, course: course).first
    return if @split_course == nil
    process_split_course(course)
  end
  
  def process_split_course(course)
    controls = Result.where(meet_id: 13, course: course).first.controls
    build_baselines(controls)
    calculate_split_results(controls)
  end
  
  def build_baselines(controls)
    control_splits = get_splits_by_control
    build_super_heroes(control_splits, controls)
  end

  def build_super_heroes(control_splits, controls)
    superman = Runner.find_or_create_by(surname: 'Admin', firstname: 'Superman')
    batman = Runner.find_or_create_by(surname: 'Admin', firstname: 'Batman')
    controls.times do |i|
      control = i+1
      Split.new(split_course_id: @split_course.id,
          control: control,
          time: control_splits[control][0],
          runner_id: superman.id).save
      avg_time = get_harmonic_mean(control_splits[control])
      Split.new(split_course_id: @split_course.id,
          control: control,
          time: avg_time,
          runner_id: batman.id).save
    end
  end

  
  def get_splits_by_control
    control_splits = Hash.new
    splits = Split.where(split_course_id: @split_course.id).order(:control, :time)
    splits.each do |s|
      if control_splits[s.control] == nil
        control_splits[s.control] = []
      end
      control_splits[s.control] << s.time
    end
    control_splits
  end
  
  def calculate_split_results(controls)
    batman = Runner.find_or_create_by(surname: 'Admin', firstname: 'Batman')
    batman_splits = Split.where(split_course_id: @split_course.id,
                                runner_id: batman.id).pluck(:time)
    runners = Split.where(split_course_id: @split_course.id)
                     .select(:runner_id).distinct
    runners.each do |r|
      process_runner_splits(r.runner_id, batman_splits, controls)
    end
  end
  
  def process_runner_splits(runner_id, batman_splits, controls)
    runner_splits = Split.where(split_course_id: @split_course.id,
                                runner_id: runner_id).order(:control)
    speed = calculate_runner_speed(runner_splits, batman_splits, controls)
    time_lost = update_time_gained_lost(runner_splits, batman_splits, speed, controls)
    create_control_splits(runner_id, speed, time_lost)
  end
  
  def create_control_splits(runner_id, speed, time_lost)
    Split.new(split_course_id: @split_course.id,
          control: SPEED_SPLIT,
          time: time_lost,
          runner_id: runner_id).save
    Split.new(split_course_id: @split_course.id,
          control: TIME_LOST_SPLIT,
          time: time_lost,
          runner_id: runner_id).save
  end
  
  def update_time_gained_lost(runner_splits, batman_splits, speed, controls)
    total_time_lost = 0.0
    runner_splits.each do |s|
      if s.time
        expected = batman_splits[s.control-1] / speed
        delta = expected - s.time
        if (-delta) > (s.time * 0.10)
          total_time_lost += delta
        end
        s.time_diff = delta
        s.save
      end
      if s.control == controls
        break
      end
    end
    total_time_lost
  end
  
  def calculate_runner_speed(runner_splits, batman_splits, controls)
    runner_scores = []
    runner_splits.each do |s|
      if s.time
        performance = batman_splits[s.control-1] / s.time
        runner_scores << performance
      end
      if s.control == controls
        break
      end
    end
    runners_speed = get_runners_speed(runner_scores)
  end
  
  def get_runners_speed(runner_scores)
    avg = get_harmonic_mean(runner_scores)
    low_boundary = avg - (avg*0.20)
    core_scores = [] # remove low outliers
    runner_scores.each do |s|
      if s > low_boundary
        core_scores << s
      end
    end
    get_harmonic_mean(core_scores)
  end

end
