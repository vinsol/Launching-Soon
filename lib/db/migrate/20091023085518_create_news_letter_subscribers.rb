class CreateNewsLetterSubscribers < ActiveRecord::Migration
  def self.up
    create_table :news_letter_subscribers do |t|
      t.string :name, :email
      
      t.timestamps
    end
    add_index :news_letter_subscribers, :email
  end

  def self.down
    drop_table :news_letter_subscribers
  end
end
