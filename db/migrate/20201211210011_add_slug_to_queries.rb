class AddSlugToQueries < ActiveRecord::Migration[5.1]
  def change
    add_column :queries, :slug, :string
    add_index :queries, :slug
    add_column :queries, :module, :string
    add_index :queries, :module
  end
end
