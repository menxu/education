class CreateExchangeMessage < ActiveRecord::Migration
  def change
    def change
      create_table :exchange_messages do |t|
        t.integer  :sender_id
        t.integer  :receiver_id
        t.text     :content
        t.boolean  :receiver_read, :default => false
        t.boolean  :sender_hide,   :default => false
        t.boolean  :receiver_hide, :default => false

        t.timestamps
      end

      add_index :exchange_messages, :sender_id
      add_index :exchange_messages, :receiver_id

    end
  end
end
