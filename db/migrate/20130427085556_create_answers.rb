class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :content

      t.timestamps
    end
  end
end
