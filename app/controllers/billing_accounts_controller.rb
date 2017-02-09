class BillingAccountsController < AuthenticatedController
  before_action :set_billing_account, only: [:show, :edit, :update, :destroy]

  helper_method :show_params

  # GET /billing_accounts
  # GET /billing_accounts.json
  def index
    @billing_accounts = current_user.billing_accounts.page(params[:page])
  end

  # GET /billing_accounts/1
  # GET /billing_accounts/1.json
  def show
    @bills = @billing_account.bills
    if params[:status] == 'paid'
    	@bills = @bills.where.not(credit_id: nil).unscope(:order).order(expiration: :desc, name: :asc)
    elsif params[:status] == 'unpaid'
    	@bills = @bills.where(credit_id: nil).unscope(:order).order(expiration: :asc, name: :asc)
    end
    @bills = @bills.page params[:page]
  end

  # GET /billing_accounts/new
  def new
    @billing_account = current_user.billing_accounts.build
  end

  # GET /billing_accounts/1/edit
  def edit
  end

  # POST /billing_accounts
  # POST /billing_accounts.json
  def create
    @billing_account = current_user.billing_accounts.build(billing_account_params)

    respond_to do |format|
      if @billing_account.save
        format.html { redirect_to @billing_account, notice: 'Grupo de despesas criado' }
        format.json { render :show, status: :created, location: @billing_account }
      else
        format.html { render :new }
        format.json { render json: @billing_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billing_accounts/1
  # PATCH/PUT /billing_accounts/1.json
  def update
    respond_to do |format|
      if @billing_account.update(billing_account_params)
        format.html { redirect_to @billing_account, notice: 'Grupo de despesas atualizado' }
        format.json { render :show, status: :ok, location: @billing_account }
      else
        format.html { render :edit }
        format.json { render json: @billing_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billing_accounts/1
  # DELETE /billing_accounts/1.json
  def destroy
    @billing_account.destroy
    respond_to do |format|
      format.html { redirect_to billing_accounts_url, notice: 'Grupo de despesas excluído' }
      format.json { head :no_content }
    end
  end

  def show_params
  	  params.permit(:id, :page, :status)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing_account
      @billing_account = current_user.billing_accounts.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def billing_account_params
      params.require(:billing_account).permit(:name, :enabled)
    end
end
