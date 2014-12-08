class AddAnswermarkToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :answer_mark, :boolean
  end
end
