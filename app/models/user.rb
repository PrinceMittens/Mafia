class User < ApplicationRecord
    has_many :Topics, dependent: :destroy
    has_many :Posts,  dependent: :destroy
end
