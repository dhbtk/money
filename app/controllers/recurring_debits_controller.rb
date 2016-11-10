class RecurringDebitsController < ApplicationController
  before_action :set_recurring_debit, only: [:show, :edit, :update, :destroy]

  # GET /recurring_debits
  # GET /recurring_debits.json
  def index
    @recurring_debits = RecurringDebit.all
  end

  # GET /recurring_debits/1
  # GET /recurring_debits/1.json
  def show
  end

  # GET /recurring_debits/new
  def new
    @recurring_debit = RecurringDebit.new
  end

  # GET /recurring_debits/1/edit
  def edit
  end

  # POST /recurring_debits
  # POST /recurring_debits.json
  def create
    @recurring_debit = RecurringDebit.new(recurring_debit_params)

    respond_to do |format|
      if @recurring_debit.save
        format.html { redirect_to @recurring_debit, notice: 'Recurring debit was successfully created.' }
        format.json { render :show, status: :created, location: @recurring_debit }
      else
        format.html { render :new }
        format.json { render json: @recurring_debit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recurring_debits/1
  # PATCH/PUT /recurring_debits/1.json
  def update
    respond_to do |format|
      if @recurring_debit.update(recurring_debit_params)
        format.html { redirect_to @recurring_debit, notice: 'Recurring debit was successfully updated.' }
        format.json { render :show, status: :ok, location: @recurring_debit }
      else
        format.html { render :edit }
        format.json { render json: @recurring_debit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recurring_debits/1
  # DELETE /recurring_debits/1.json
  def destroy
    @recurring_debit.destroy
    respond_to do |format|
      format.html { redirect_to recurring_debits_url, notice: 'Recurring debit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recurring_debit
      @recurring_debit = RecurringDebit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recurring_debit_params
      params.require(:recurring_debit).permit(:name, :months, :day, :value, :account_id)
    end
end
