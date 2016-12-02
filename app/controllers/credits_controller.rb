class CreditsController < ApplicationController
  before_action :set_credit, only: [:show, :edit, :update, :destroy, :to_transfer]

  # GET /credits
  # GET /credits.json
  def index
    @credits = Credit.all
  end

  # GET /credits/1
  # GET /credits/1.json
  def show
  end

  # GET /credits/new
  def new
    @credit = Credit.new
  end

  # GET /credits/1/edit
  def edit
  end

  # POST /credits
  # POST /credits.json
  def create
    @credit = Credit.new(credit_params)

    respond_to do |format|
      if @credit.save
        format.html { redirect_to statements_path, notice: 'Despesa criada' }
        format.json { render :show, status: :created, location: @credit }
      else
        format.html { render :new }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /credits/1
  # PATCH/PUT /credits/1.json
  def update
    respond_to do |format|
      if @credit.update(credit_params)
        format.html { redirect_to statements_path, notice: 'Despesa atualizada' }
        format.json { render :show, status: :ok, location: @credit }
      else
        format.html { render :edit }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credits/1
  # DELETE /credits/1.json
  def destroy
    @credit.destroy
    respond_to do |format|
      format.html { redirect_to statements_path, notice: 'Despesa excluída' }
      format.json { head :no_content }
    end
  end

  def to_transfer
    raise 'Não é permitido transferir para a mesma conta!' if to_transfer_params[:account_id] == @credit.account_id
    account = current_user.accounts.find(to_transfer_params[:account_id])
    transfer = Transfer.from_credit_and_account(@credit, account)
    respond_to do |format|
      if transfer.save
        format.html { redirect_to edit_transfer_path(transfer), notice: 'Transferência criada' }
        format.json { redirect_to transfer, status: :created, location: transfer }
      else
        format.html { render :edit }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_credit
    @credit = Credit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def credit_params
    params.require(:credit).permit(:name, :date, :value, :account_id, :months, :tag_id)
  end

  def to_transfer_params
    params.permit(:id, :account_id)
  end
end
