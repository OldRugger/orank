class RenamePowerRankingClassColumn < ActiveRecord::Migration[4.2]
  def change
    rename_column :power_rankings, :class, :ranking_class
  end
end
