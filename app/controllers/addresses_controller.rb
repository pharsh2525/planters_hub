class AddressesController < ApplicationController
  before_action :authenticate_user! # Assuming you're using Devise or similar
  before_action :set_address, only: [:show, :edit, :update, :destroy]

  # GET /addresses
  def index
    @addresses = current_user.addresses
  end

  # GET /addresses/1
  def show
    # Show view logic (if any)
  end

  # GET /addresses/new
  def new
    @address = current_user.addresses.build
  end

  # GET /addresses/1/edit
  def edit
    # Edit view logic (if any)
  end

  # POST /addresses
  def create
    @address = current_user.addresses.build(address_params)

    if @address.save
      redirect_to @address, notice: 'Address was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /addresses/1
  def update
    if @address.update(address_params)
      redirect_to @address, notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /addresses/1
  def destroy
    @address.destroy
    redirect_to addresses_url, notice: 'Address was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_address
    @address = current_user.addresses.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def address_params
    params.require(:address).permit(:address, :city, :postal_code, :user_id, :province_id)
  end
end
