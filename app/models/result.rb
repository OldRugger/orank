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
        validate_file_type(row)
      else
        first = false
      end
      load_result(meet_id, row)
    end
  end
  # note: this is a workaround for a ruby_parser error
  private_class_method :load_results

  private_class_method def self.clear_existing_results(meet_id)
    Result.where(meet_id: meet_id).delete_all
  end

  private_class_method def self.load_result(meet_id, row)
    runner = Runner.get_runner(row)
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
                        include: true)
    result.save
  end

  private_class_method def self.validate_file_type(row)
    raise 'Unsupported file type - not OE0014' unless row.header?('OE0014')
  end

  private_class_method def self.get_float_time(time)
    if time.scan(/(?=:)/).count == 2
      hh, mm, ss = time.split(':')
    else
      hh = 0
      mm, ss = time.split(':')
    end
    (hh * 60) + mm + (ss / 60.0)
  end
end
