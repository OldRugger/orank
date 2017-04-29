# Runner - individual runner record
class Runner < ActiveRecord::Base
  def self.get_runner(row)
    # first match by chipno, and name.
    runner = Runner.where(card_id: row['Chipno'],
                          surname: row['Surname'],
                          firstname: row['First Name']).first
    return runner if runner
    # match on name
    runner = Runner.where(surname: row['surname'],
                          firstname: row['First Name']).first
    return update_card_id(runner, row['Chipno']) if runner
    create_runner(row)
  end

  private_class_method def self.update_card_id(runner, card_id)
    runner.card_id = card_id
    runner.save
    runner
  end

  private_class_method def self.create_runner(row)
    runner = Runner.new(surname: row['Surname'],
                        firstname: row['First name'],
                        card_id: row['Chipno'],
                        sex: row['S'],
                        club_id: row['Club no.'],
                        club: row['Cl.name'])
    runner.save
    runner
  end
end
