class RenameProductToProvider < ActiveRecord::Migration
  def change
    rename_column :tokens, :product, :provider
  end
end
