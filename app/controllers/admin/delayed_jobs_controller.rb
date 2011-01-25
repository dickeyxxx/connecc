class Admin::DelayedJobsController < Admin::AdminController

  def index
    @delayed_jobs = Delayed::Job.order(:id)
  end

  def show
    @delayed_job = Delayed::Job.find(params[:id])
  end

end
