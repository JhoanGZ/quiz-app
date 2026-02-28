class Answer < ApplicationRecord
  belongs_to :attempt
  belongs_to :question
  belongs_to :option
end
