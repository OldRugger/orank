class RenamePowerRankingClassColumn < ActiveRecord::Migration
  def change
    rename_column :power_rankings, :class, :ranking_class
  end
end
