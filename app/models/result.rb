require 'csv'
# Result - one record for each runner, a runner can have mulitple results for a meet
class Result < ActiveRecord::Base
  belongs_to :meet
  belongs_to :runner
  def self.import(meet_id, file)
    clear_existing_results(meet_id)
    load_results(meet_id, file)
  end

  def self.load_results(meet_id, file)
    first = true
    CSV.foreach(file.tempfile.path, headers: true, col_sep: ';') do |row|
      if first == true
        file_type = validate_file_type(row)
      else
        first = false
      end
      load_result(meet_id, row, file_type)
    end
    split_yellow_runners(meet_id)
  end
  # note: this is a workaround for a ruby_parser error
  private_class_method :load_results

  private_class_method def self.clear_existing_results(meet_id)
    Result.where(meet_id: meet_id).delete_all
  end

  private_class_method def self.load_result(meet_id, row, file_type)
    runner = Runner.get_runner(row, file_type)
    runner_time = row['Time']
    result = Result.new(meet_id: meet_id,
                        runner_id: runner.id,
                        time: runner_time,
                        float_time: get_float_time(runner_time),
                        course: row['Course'],
                        length: row['km'],
                        climb: row['m'],
                        controls: row['Course controls'],
                        place: row['Place'],
                        classifier: row['Classifier'],
                        source_file_type: file_type,
                        include: true)
    result.save
  end

  private_class_method def self.validate_file_type(row)
    return 'OE0014' if row.header?('OE0014')
    return 'OR' if row.header?('SI card')
    raise 'Unsupported file type - not OE0014 or OR spits'
  end

  private_class_method def self.get_float_time(time)
    if time
      if time.scan(/(?=:)/).count == 2
        hh, mm, ss = time.split(':')
      else
        hh = 0
        mm, ss = time.split(':')
      end
      return (hh.to_i * 60) + mm.to_i + (ss.to_i / 60.0)
    end
  else
    return 0
  end
  
  # If a yellow runner also ran an upper lever course, do not include the runnes
  # the yellow results - move them to a sprint course.
  private_class_method def self.split_yellow_runners(meet_id)
    binding.pry
  end
  
end
