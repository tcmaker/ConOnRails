class DutyBoardSlotsController < ApplicationController
  before_filter :can_admin_duty_board?, except: [:update]
  before_filter :can_assign_duty_board_slots?, only: [:update]

  respond_to :html, :json

  # GET /duty_board_slots
  # GET /duty_board_slots.json
  def index
    @duty_board_slots = DutyBoardSlot.order(:duty_board_group_id, :name)
  end

  # GET /duty_board_slots/1
  # GET /duty_board_slots/1.json
  def show
    @duty_board_slot = DutyBoardSlot.find(params[:id])
  end

  # GET /duty_board_slots/new
  # GET /duty_board_slots/new.json
  def new
    @duty_board_slot = DutyBoardSlot.new
  end

  # GET /duty_board_slots/1/edit
  def edit
    @duty_board_slot = DutyBoardSlot.find(params[:id])
  end

  # POST /duty_board_slots
  # POST /duty_board_slots.json
  def create
    @duty_board_slot = DutyBoardSlot.new(params[:duty_board_slot])
    flash[:notice] = 'Duty board slot was successfully created.' if @duty_board_slot.save
    respond_with @duty_board_slot, location: :duty_board_slots
  end

  # PUT /duty_board_slots/1
  # PUT /duty_board_slots/1.json
  def update
    @duty_board_slot = DutyBoardSlot.find(params[:id])

    respond_with @duty_board_lot, location: :duty_board_index do |format|
      if @duty_board_slot.update_attributes(params[:duty_board_slot])
        if params[:duty_board_assignment]
          if @duty_board_slot.duty_board_assignment
            @duty_board_slot.duty_board_assignment.update_attributes(params[:duty_board_assignment])
          else
            @duty_board_slot.build_duty_board_assignment params[:duty_board_assignment]
            @duty_board_slot.save!
          end
          flash[:notice] = 'Duty board slot was successfully updated'
        else
          flash[:notice] = 'Duty board slot was successfully updated'
        end
      end
    end
  end

  # POST /duty_board_slots/1/clear_assignment
  def clear_assignment
    @duty_board_slot = DutyBoardSlot.find params[:id]

    if @duty_board_slot.duty_board_assignment
      @duty_board_slot.duty_board_assignment.destroy
    end

    respond_to do |format|
      format.html { redirect_to duty_board_index_path, notice: 'Duty board slot was successfully cleared' }
    end
  end

  # DELETE /duty_board_slots/1
  # DELETE /duty_board_slots/1.json
  def destroy
    @duty_board_slot = DutyBoardSlot.find(params[:id])
    @duty_board_slot.destroy

    respond_to do |format|
      format.html { redirect_to duty_board_slots_url }
      format.json { head :ok }
    end
  end
end
