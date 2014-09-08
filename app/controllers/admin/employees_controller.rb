class Admin::EmployeesController < ApplicationController
  respond_to :html
  before_filter :require_employee_signin

  def index
    @employees = Employee.all
  end

  def create
    @employee = Employee.new(employee_params)

    redirect_to admin_provider_employees_path and return if @employee.save
    redirect_to new_admin_provider_employee_path
  end

  def new
    @employee = Employee.new
    @provider = Provider.find(employee_params[:provider_id])
  end

  def edit
    @employee = Employee.find(employee_params[:id])
  end

  def show
    @employee = Employee.find(employee_params[:id])
  end

  def update
    employee = Employee.find(employee_params[:id])

    if employee.update(employee_params) 
      redirect_to admin_provider_employee_path(employee.provider_id, employee) 
    elsif employee_params.fetch(:password, []).empty?
      employee.update_attribute(:provider_id, employee_params[:name])
      employee.update_attribute(:name, employee_params[:name])
      employee.update_attribute(:email, employee_params[:name])
      employee.update_attribute(:phone_number, employee_params[:name])
      redirect_to admin_provider_employee_path(employee.provider_id, employee) 
    else
      redirect_to admin_edit_provider_employee_path(employee.provider_id, employee)
    end
  end

  def destroy
    Employee.destroy(employee_params[:id])

    redirect_to admin_provider_employees_path
  end

  private

  def employee_params
    params.require(:employee).permit(:provider_id, :name, :email, :remember_token, :password, :password_confirmation, :phone_number)
  end
end