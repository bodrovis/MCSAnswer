class AddCurrentToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :current, :boolean
    add_index :questions, :current
  end
end
