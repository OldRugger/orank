require 'csv'
# Result - one record for each runner, a runner can have mulitple results for a meet
class Result < ActiveRecord::Base
  belongs_to :meet
  belongs_to :runner
  def self.import(meet_id, file)
    Result.new.import(meet_id, file)
  end
  
  def import(meet_id, file)
    clear_existing_results(meet_id)
    load_results(meet_id, file)
    File.delete(file.tempfile.path) if File.exist?(file.tempfile.path)
  end

  private
  
  def load_results(meet_id, file)
    file_type = nil
    first     = true
    recs      = 0
    CSV.foreach(file.tempfile.path, skip_blanks: true, headers: true, col_sep: ';') do |row|
      next if row.empty?
      recs += 1
      if first == true
        file_type = validate_file_type(row)
        first = false
      end
      load_result(meet_id, row, file_type)
      Split.load_results(meet_id, row, file_type)
    end
    Rails.logger.info("\n---> #{recs} records added for meet_id: #{meet_id}\n")
    split_yellow_runners(meet_id)
  end

  def clear_existing_results(meet_id)
    Result.where(meet_id: meet_id).destroy_all
    SplitCourse.where(meet_id: meet_id).destroy_all
  end

  def load_result(meet_id, row, file_type)
    runner = Runner.get_runner(row, file_type)
    runner_time = row['Time']
    place = file_type === 'OR' ? 'Pl' : 'Place'
    result = Result.new(meet_id: meet_id,
                        runner_id: runner.id,
                        time: runner_time,
                        float_time: get_float_time(runner_time),
                        course: row['Course'].capitalize,
                        length: row['km'],
                        climb: row['m'],
                        controls: row['Course controls'],
                        gender: runner.sex,
                        place: row[place],
                        classifier: row['Classifier'],
                        source_file_type: file_type,
                        include: true)
    result.save
  end

  def validate_file_type(row)
    return 'OE0014' if row.header?('OE0014')
    return 'OR' if row.header?('SI card')
    raise 'Unsupported file type - not OE0014 or OR spits'
  end

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
  
  # If a yellow runner also ran an upper lever course, do not include the runnes
  # the yellow results - move them to a sprint course.
  def split_yellow_runners(meet_id)
    runs = Result.where(meet_id: meet_id).group('runner_id').count
    runs.each do |i, r|
      if r > 1
        next if Result.where(runner_id: i, course: 'White').count > 0
        set_yellow_result_to_sprint(meet_id, i)
      end
    end
  end
  
  def set_yellow_result_to_sprint(meet_id, runner_id)
    result = Result.where(runner_id: runner_id, meet_id: meet_id, course: 'Yellow').first
    return unless result
    result.course = 'Sprint'
    result.save
    update_split_runner(result)
  end
  
  def update_split_runner(result)
    @source_split_course = SplitCourse.where(meet_id: result.meet_id, course: 'Yellow').first
    @dest_split_course ||= split_course = SplitCourse.find_or_create_by(meet_id: result.meet_id,
                                                 controls: @source_split_course.controls,
                                                 course: result.course)
    split_runner = SplitRunner.where(runner_id: result.runner_id,
                                     split_course_id: @source_split_course.id).first
    split_runner.split_course_id = @dest_split_course.id
    split_runner.save
  end
end
