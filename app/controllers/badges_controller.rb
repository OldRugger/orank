class BadgesController < ApplicationController

  def create
    puts "create badges"
    @season = APP_CONFIG[:season]
    @meets = get_season_meets(@season)
    create_navigation_badges
    redirect_to controller: 'admin', action: 'index'
  end
  
  def get_season_meets(season)
    temp = season.split('/')
    start_date = Date.new(2000+temp[0].to_i, 7, 1)
    end_date = Date.new(2000+temp[1].to_i, 7, 1)
    Meet.where(date: start_date..end_date).pluck(:id)
  end
  
  def create_navigation_badges
    Badge.where(season: @season).all.delete_all
    runners = Runner.all
    runners.each do |r|
      create_courses_badges(r)
      expert = check_expert(r)
      next if expert
      pathfinder = check_pathfinder(r)
      next if pathfinder
      check_navigator(r)
    end
  end
  
  def create_courses_badges(r)
    ['Red','Green','Brown','Orange','Yellow','Sprint'].each do |course|
      create_ribbons(course, r)
      count = Result.where(meet: @meets, course: course, classifier: 0, runner_id: r.id).count
      if count >= 2
        create_course_badges(course, count, r)
      end
    end
  end

  def create_ribbons(course, runner)
    podiums =  Result.where(meet: @meets, course: course, classifier: 0, runner_id: runner.id, place: 1..3)
    podiums.each do |p|
      case p.place
      when 1
        badge_type = "First"
      when 2
        badge_type = "Second"
      when 3
        badge_type = "Third"
      end
      meet = Meet.find(p.meet_id)
      Badge.new(runner_id: runner.id, season: @season, badge_type: badge_type,
                class_type: course, value: p.place, sort: 30,
                text: "#{badge_type} place finish on #{course} at #{meet.name} on #{meet.date}").save
    end
  end
  
  def create_course_badges(course, count, runner)
    [15, 10, 5, 2].each do |c|
      if count >= c
        puts "create badge #{course} #{c} #{runner.name}"
        Badge.new(runner_id: runner.id, season: @season, badge_type: 'course',
                  class_type: course, value: c, sort: c,
                  text: "Runner has completed at least #{c} #{course} courses").save!
      end
    end
  end
  
  def check_expert(runner)
    return true if Badge.where(runner_id: runner.id, season: @season, badge_type: "performance", class_type: 'Expert').count > 0
    courses = ['Red', 'Green']
    if runner.sex == 'M'
      standard = 10.0
    else
      standard = 11.25
      courses << 'Brown'
    end
    results = Result.where(meet_id: @meets, runner_id: runner.id, course: courses, classifier: 0).all
    count = 0
    results.each do |r|
      pace = r.float_time/r.length
      count +=1 if pace < standard
      if count >= 2
        create_expert(runner)
        return true
      end
    end
    false
  end
  
  def create_expert(runner)
    puts "Captain #{runner.name}  #{runner.club_description} "
    Badge.new(runner_id: runner.id, season: @season, badge_type: "performance",
              class_type: "Expert", value: 'E', sort: 1,
              text: "Expert! The runner had at least two races meeting the 'expert' standard").save
  end
  
  def check_pathfinder(runner)
    return true if Badge.where(runner_id: runner.id, season: @season, badge_type: "performance", class_type: 'Pathfinder').count > 0
    courses = ['Red', 'Green']
    if runner.sex == 'M'
      standard = 12.0
    else
      standard = 13.5
      courses << 'Brown'
    end
    results = Result.where(meet_id: @meets, runner_id: runner.id, course: courses, classifier: 0).all
    count = 0
    results.each do |r|
      pace = r.float_time/r.length
      count +=1 if pace < standard
      if count >= 2
        binding.pry
        create_pathfinder(runner)
        return true
      end
    end
    false
  end
  
  def create_pathfinder(runner)
    puts "Master #{runner.name}  #{runner.club_description} "
    Badge.new(runner_id: runner.id, season: @season, badge_type: "performance",
              class_type: "Pathfinder", sort: 1, value: "P",
              text: "Pathfinder! The runner had at least two races meeting the 'Pathfinder' standard").save
  end
  
  def check_navigator(runner)
    return true if Badge.where(runner_id: runner.id, season: @season, badge_type: "performance", class_type: 'Navigator').count > 0
    courses = ['Red', 'Green']
    if runner.sex == 'M'
      standard = 15.0
    else
      standard = 17
      courses << 'Brown'
    end
    results = Result.where(meet_id: @meets, runner_id: runner.id, course: courses, classifier: 0).all
    count = 0
    results.each do |r|
      pace = r.float_time/r.length
      count +=1 if pace < standard
      if count >= 2
        create_navigator(runner)
        return true
      end
    end
    false
  end
  
  def create_navigator(runner)
    puts "Boatswain #{runner.name} #{runner.club_description} "
    Badge.new(runner_id: runner.id, season: @season, badge_type: "performance",
              class_type: "Navigator", sort: 1, value: "N",
              text: "Navigator! The runner had at least two races meeting the 'Navigator' standard").save
  end
end