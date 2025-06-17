class InitializeTables < ActiveRecord::Migration[8.0]
  def change
    # Organizations table
    create_table :organizations do |t|
      t.string :name

      t.timestamps
    end

    # Users table
    create_table :users do |t|
      t.string :username, null: false
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.references :organization, null: true, foreign_key: true

      t.timestamps
    end
    add_index :users, :email_address, unique: true

    # Sessions table
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end

    # Permissions table
    create_table :permissions do |t|
      t.string :name
      t.string :resource
      t.string :action

      t.timestamps
    end

    # Roles table
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end

    # Role Permissions table
    create_table :role_permissions do |t|
      t.references :role, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true

      t.timestamps
    end

    # User Roles table
    create_table :user_roles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end

    # User Permissions table
    create_table :user_permissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true
      t.references :organization, null: true, foreign_key: true

      t.timestamps
    end
  end
end
