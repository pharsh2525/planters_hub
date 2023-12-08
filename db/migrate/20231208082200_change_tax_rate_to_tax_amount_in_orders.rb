class ChangeTaxRateToTaxAmountInOrders < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :gst_rate, :gst_amount
    rename_column :orders, :pst_rate, :pst_amount
    rename_column :orders, :hst_rate, :hst_amount

    # Change the type if necessary, e.g., from :decimal to :float
    # change_column :orders, :gst_amount, :float
    # change_column :orders, :pst_amount, :float
    # change_column :orders, :hst_amount, :float
  end
end
