class AddProviderToToken < ActiveRecord::Migration
  def change
    add_column :tokens, :product, :string
  end
end
