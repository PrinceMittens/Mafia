class Post < ApplicationRecord
    belongs_to :User
    belongs_to :Topic
end
