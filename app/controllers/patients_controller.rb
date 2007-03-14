class PatientsController < ApplicationController

  def live_search
    @phrase = (request.raw_post || request.query_string).slice(/[^=]+/)
    if @phrase.blank?
      render(:file => 'forms/_new_form', :use_full_path => true)
    else
      @sqlphrase = "%" + @phrase.to_s + "%"
      @results = Patient.find(:all, :conditions => [ "account_number LIKE ? OR last_name LIKE ? OR first_name LIKE ? OR social_security_number LIKE ? OR telephone LIKE ?", @sqlphrase, @sqlphrase, @sqlphrase, @sqlphrase, @sqlphrase])
      @search_entity = @results.length == 1 ? "Patient" : "Patients"
      render(:file => 'shared/live_search_results', :use_full_path => true, :locals => { :proxy_partial => @results.length == 0 ? 'forms/new_form' : 'live_search_results', :show_null_results => true })
    end
  end
  
  def show
    @patient = Patient.find_by_id(params[:id])
  end
  
  # DELETE /patients/1
  # DELETE /patients/1.xml
  def destroy
    @patient = Patient.find_by_id(params[:id])
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to mydashboard_path(:domain => params[:domain]) }
      format.xml  { head :ok }
    end
  end

end
