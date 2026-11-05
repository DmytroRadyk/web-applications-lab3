class AddSearchTextToCastles < ActiveRecord::Migration[7.2]
  def up
    add_column :castles, :search_text, :text, null: false, default: ""
    # Normalize Unicode in Ruby because SQLite LOWER only handles ASCII.
    model = Class.new(ActiveRecord::Base) { self.table_name = "castles" }
    model.find_each { |castle| castle.update_columns(search_text: "#{castle.name} #{castle.location}".downcase) }
  end

  def down
    remove_column :castles, :search_text
  end
end
