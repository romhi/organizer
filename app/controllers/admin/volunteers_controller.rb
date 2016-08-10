class Admin::VolunteersController < ApplicationController

  before_filter :authenticate_user!
  authorize_resource

  before_filter :load_model, only: [:edit, :show, :update, :destroy]

  def index
    scope = Volunteer.joins(:congregation)
    @part, @order, @congregation_id, @vacancy = nil, nil, nil, nil
    if params[:volunteer]
      @part = params[:volunteer][:part]
      @order = params[:volunteer][:order]
      @congregation_id = params[:volunteer][:congregation_id]
      @vacancy = params[:volunteer][:vacancy]
      scope = scope.where("email ilike :part or first_name ilike :part or last_name ilike :part or phone ilike :part", part: "%#{@part}%") if @part.present?
      scope = scope.where("congregation_id = ?", @congregation_id) if @congregation_id.present?
      scope = scope.where("vacancy_id is null") if @vacancy == "2"
      scope = scope.where("vacancy_id is not null") if @vacancy == "1"
      scope = scope.order("#{@order}") if @order.present?
    end
    @volunteers = scope.paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new params_volunteer
    if @volunteer.save
      redirect_to admin_volunteers_path, notice: "Доброволец успешно создан!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @volunteer.update params_volunteer
      redirect_to admin_volunteers_path, notice: "Информация о добровольце обновлена"
    else
      render :edit
    end
  end

  def destroy
    @volunteer.destroy
    redirect_to admin_volunteers_path
  end

  private

  def params_volunteer
    params.require(:volunteer).permit(:congregation_id, :last_name, :first_name, :age, :service_time_id,
                                      :convenient_start_time, :convenient_end_time, :will_be_since_8, :car,
                                      :will_be_until_17, :outdoor,  :service_id, :phone,:email, :comment, :responsibility_id)
  end

  def load_model
    @volunteer = Volunteer.find params[:id]
  end


end

