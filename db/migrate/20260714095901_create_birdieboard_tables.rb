class CreateBirdieboardTables < ActiveRecord::Migration[8.0]
  def change
    create_table :tournaments do |t|
      t.references :organiser, null: false, foreign_key: { to_table: :users }
      t.string  :name,             null: false
      t.string  :location
      t.date    :date
      t.string  :format,           null: false, default: "stableford"
      t.string  :state,            null: false, default: "draft"
      t.string  :team1_name,       default: "Team A"
      t.string  :team2_name,       default: "Team B"
      t.string  :team_trophy
      t.string  :individual_trophy
      t.integer :entry_fee_pence,  default: 0
      t.integer :cttp_fee_pence,   default: 0
      t.text    :notes
      t.timestamps
    end
    add_index :tournaments, :state
    add_index :tournaments, :date

    create_table :invitations do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :user,                    foreign_key: true
      t.string  :email,   null: false
      t.string  :token,   null: false
      t.string  :status,  null: false, default: "pending"
      t.datetime :sent_at
      t.datetime :accepted_at
      t.timestamps
    end
    add_index :invitations, :token,                         unique: true
    add_index :invitations, [ :tournament_id, :email ],     unique: true
    add_index :invitations, :status

    create_table :entries do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :user,       null: false, foreign_key: true
      t.integer :playing_handicap
      t.string  :team
      t.boolean :entered_cttp_front, default: false
      t.boolean :entered_cttp_back,  default: false
      t.string  :payment_status,     null: false, default: "unpaid"
      t.string  :stripe_session_id
      t.integer :amount_paid_pence,  default: 0
      t.timestamps
    end
    add_index :entries, [ :tournament_id, :user_id ], unique: true
    add_index :entries, :payment_status
    add_index :entries, :stripe_session_id, unique: true, where: "stripe_session_id IS NOT NULL"

    create_table :rounds do |t|
      t.references :tournament, null: false, foreign_key: true
      t.integer :day_number, null: false
      t.string  :course_name
      t.json    :course_par
      t.json    :course_si
      t.string  :format, default: "stableford"
      t.timestamps
    end
    add_index :rounds, [ :tournament_id, :day_number ], unique: true

    create_table :scores do |t|
      t.references :round,       null: false, foreign_key: true
      t.references :user,        null: false, foreign_key: true
      t.references :approved_by, foreign_key: { to_table: :users }
      t.json     :gross_scores
      t.string   :status, null: false, default: "draft"
      t.datetime :approved_at
      t.text     :ocr_raw
      t.timestamps
    end
    add_index :scores, [ :round_id, :user_id ], unique: true
    add_index :scores, :status
  end
end
