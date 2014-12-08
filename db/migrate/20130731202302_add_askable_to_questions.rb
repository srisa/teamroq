class AddAskableToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :askable_id, :integer
    add_column :questions, :askable_type, :string
  end
end
