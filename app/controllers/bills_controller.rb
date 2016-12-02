class BillsController < ApplicationController
  before_action :set_billing_account, only: [:new, :create]
  before_action :set_bill, only: [:edit, :update, :destroy]

  def new
    @bill = @billing_account.bills.build
  end

  def create
    @bill = @billing_account.bills.build(bill_params)

    if @bill.save
      redirect_to @billing_account, notice: 'Despesa criada'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @bill.update(bill_params)
      redirect_to @bill.billing_account, notice: 'Despesa atualizada'
    else
      render :edit
    end
  end

  def destroy
    @bill.destroy
    redirect_to @bill.billing_account, notice: 'Despesa excluída'
  end

  private

  def set_billing_account
    @billing_account = current_user.billing_accounts.find(params[:billing_account_id])
  end

  def set_bill
    @bill = current_user.bills.find(params[:id])
  end

  def bill_params
    params.require(:bill).permit(:name, :value, :expiration)
  end
end