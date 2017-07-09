class Split < ActiveRecord::Base
  belongs_to :split_runner
  
  def self.load_results(meet_id, row, file_type)
    self.new.load_results(meet_id, row, file_type)
  end
  
  def load_results(meet_id, row, file_type)
    return if row['Classifier'] != '0'
    split_course = SplitCourse.find_or_create_by(meet_id: meet_id,
                                                 course: row['Course'].capitalize)
    if file_type == 'OE0014'
      load_oe0014_splits(split_course, row)
    elsif file_type == 'OR'
      load_or_splits(split_course, row)
    end
  end
  
  def load_oe0014_splits(split_course, row)
    split_runner = get_split_runner(split_course, row, 'OE0014')
    last_control = 0.0
    60.times do |i|
      control = i+1
      break if row["Punch#{control}"] == nil
      current_time = get_float_time(row["Punch#{control}"])
      time = current_time - last_control
      Split.new(split_runner_id: split_runner.id,
                current_time: current_time,
                control: control,
                time: time).save
      last_control = current_time
    end
    time = split_runner.total_time - last_control
    Split.new(split_runner_id: split_runner.id,
          current_time: split_runner.total_time,
          control: FINAL_SPLIT,
          time: time).save
  end
  
  def get_split_runner(split_course, row, source)
    runner = Runner.get_runner(row, source)
    if source == 'OE0014'
      split_runner = SplitRunner.new(split_course_id: split_course.id,
                                     runner_id: runner.id,
                                     start_punch: row['Start'],
                                     finish_punch: row['Finish'],
                                     place: row['Place'],
                                     total_time: get_float_time(row['Time']))
    end
    split_runner.save
    split_runner
  end
  
  def load_or_splits(split_runner, row)
    last_control = 0.0
    first_punch = row.find_index { |k,_| k== 'Punch1' }
    60.times do |i|
      control = i * 2 + first_punch
      break if row[control] == nil
      runner = Runner.get_runner(row, 'or')
      time = get_float_time(row[control]) - last_control
      Split.new(split_course_id: split_runner.id,
                control: control,
                time: time,
                runner_id: runner.id).save
      last_control += time
    end
    time = split_runner.total_time - last_control
    Split.new(split_runner_id: split_runner.id,
          control: FINAL_SPLIT,
          time: time).save

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

end
