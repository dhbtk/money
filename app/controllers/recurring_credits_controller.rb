class RecurringCreditsController < ApplicationController
  before_action :set_recurring_credit, only: [:show, :edit, :update, :destroy]

  # GET /recurring_credits
  # GET /recurring_credits.json
  def index
    @recurring_credits = RecurringCredit.all
  end

  # GET /recurring_credits/1
  # GET /recurring_credits/1.json
  def show
  end

  # GET /recurring_credits/new
  def new
    @recurring_credit = RecurringCredit.new
  end

  # GET /recurring_credits/1/edit
  def edit
  end

  # POST /recurring_credits
  # POST /recurring_credits.json
  def create
    @recurring_credit = RecurringCredit.new(recurring_credit_params)

    respond_to do |format|
      if @recurring_credit.save
        format.html { redirect_to @recurring_credit, notice: 'Recurring credit was successfully created.' }
        format.json { render :show, status: :created, location: @recurring_credit }
      else
        format.html { render :new }
        format.json { render json: @recurring_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recurring_credits/1
  # PATCH/PUT /recurring_credits/1.json
  def update
    respond_to do |format|
      if @recurring_credit.update(recurring_credit_params)
        format.html { redirect_to @recurring_credit, notice: 'Recurring credit was successfully updated.' }
        format.json { render :show, status: :ok, location: @recurring_credit }
      else
        format.html { render :edit }
        format.json { render json: @recurring_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recurring_credits/1
  # DELETE /recurring_credits/1.json
  def destroy
    @recurring_credit.destroy
    respond_to do |format|
      format.html { redirect_to recurring_credits_url, notice: 'Recurring credit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recurring_credit
      @recurring_credit = RecurringCredit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recurring_credit_params
      params.require(:recurring_credit).permit(:name, :months, :day, :value, :account_id, :expiration, :interest, :fine)
    end
end
