# Runner - individual runner record
class Runner < ActiveRecord::Base
  def self.get_runner(row, file_type)
    # first match by chipno, and name.
    runner = match_runner_card_id(row, file_type)
    return update_runner(row, runner, file_type) if runner
    # match on name
    runner = Runner.where(surname: row['Surname'],
                          firstname: row['First name']).first
    return update_runner(row, runner, file_type) if runner
    create_runner(row, file_type)
  end
  
  def name
    "#{self.firstname} #{self.surname}"
  end
  
  private_class_method def self.match_runner_card_id(row, file_type)
    runner = nil
    if file_type == 'OE0014'
      runner = Runner.where(card_id: row['Chipno'],
                            surname: row['Surname'],
                            firstname: row['First name']).first
    else
      runner = Runner.where(card_id: row['SI card'],
                            surname: row['Surname'],
                            firstname: row['First name']).first
    end
  end

  private_class_method def self.create_runner(row, file_type)
    if file_type == 'OE0014'
      return create_runner_oe00014(row)
    end
    create_runner_or(row)
  end

  private_class_method def self.create_runner_oe00014(row)
    runner = Runner.new(surname: row['Surname'],
                        firstname: row['First name'],
                        card_id: row['Chipno'],
                        sex: row['S'],
                        club_id: row['Club no.'],
                        club: row['Cl.name'],
                        club_description: row['City'])
    logger.info("runner #{runner.firstname} #{runner.surname} added to database - OE0014")
    runner.save
    runner
  end

  private_class_method def self.create_runner_or(row)
    runner = Runner.new(surname: row['Surname'],
                        firstname: row['First name'],
                        sex: row['S'],
                        card_id: row['SI card'],
                        club_description: row['City'])
    logger.info("runner #{runner.firstname} #{runner.surname} #{runner.sex} added to database - OR")
    runner.save
    runner
  end
  
  #update runners club info
  private_class_method def self.update_runner(row, runner, file_type)
    # Treat OR as an external data source
    return runner if file_type == 'OR'
    # if club changed, update runner record
    if runner.club != row['Cl.name']
      logger.info("runner #{runner.firstname} #{runner.surname} club updated")
      runner.club_id          = row['Club no.']
      runner.club             = row['Cl.name']
      runner.club_description = row['City']
      runner.save
    end
    runner
  end
  
end
