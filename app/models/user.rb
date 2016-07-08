class User < ApplicationRecord
    has_many :Topics
    has_many :Posts
end
