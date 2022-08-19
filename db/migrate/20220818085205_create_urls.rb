# frozen_string_literal: true

class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls do |t|
      t.text :long_url
      t.text :url_code
      t.text :short_url

      t.timestamps
    end
  end
end
