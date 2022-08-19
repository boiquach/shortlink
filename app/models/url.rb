# frozen_string_literal: true

class Url < ApplicationRecord
  validates :long_url, presence: true
  validates :short_url, presence: true
  validates :url_code, presence: true
end
