class NotesController < ApplicationController
  # before_filter :validate_doctor_and_form_type

  # GET /notes
  # GET /notes.xml
  def index
    restrict('allow only doctor users') or begin
      @form_instance = FormInstance.find_by_form_type_and_form_id(params[:form_type], params[:form_id])
      @notes = Note.find_by_form_instance_id(@form_instance.id)
      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => @notes.to_xml }
      end
    end
  end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    restrict('allow only doctor users') or begin
      @note = Note.find_by_id(params[:id])
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @note.to_xml }
      end
    end
  end

  # GET /notes/new
  def new
    restrict('allow only doctor users') or begin
      @note = Note.new
    end
  end

  # GET /notes/1;edit
  def edit
    restrict('allow only doctor users') or begin
      @note = Note.find_by_id(params[:id])
      return render :ok unless current_user == @note.author #Only allow the user who created the note to edit it.
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  # POST /notes
  # POST /notes.xml
  def create
    restrict('allow only doctor users') or begin
      @note = Note.new(params[:note])
      @note.form_instance = current_form_instance
      @note.author = current_user
      respond_to do |format|
        if @note.save
          format.html { redirect_to doctor_forms_url(:form_status => @note.form_instance.status, :action => 'draft', :form_type => params[:form_type], :form_id => params[:form_id]) }
          format.js   {}
          format.xml  { head :created, :location => doctor_forms_url(:form_status => @note.form_instance.status, :action => 'draft', :form_type => params[:form_type], :form_id => params[:form_id]) }
        else
          format.html { render :action => "new" }
          format.js   {}
          format.xml  { render :xml => @note.errors.to_xml }
        end
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    restrict('allow only doctor users') or begin
      @note = Note.find_by_id(params[:id])
      @note.form_instance = current_form_instance
      @note.author = current_user
      respond_to do |format|
        if @note.update_attributes(params[:note])
          format.html { redirect_to doctor_forms_url(:form_status => @note.form_instance.status, :action => 'draft', :form_type => params[:form_type], :form_id => params[:form_id]) }
          format.js   {}
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.js   {}
          format.xml  { render :xml => @note.errors.to_xml }
        end
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    restrict('allow only doctor users') or begin
      @note = Note.find_by_id(params[:id])
      status = @note.form_instance.status
      @note.destroy
      respond_to do |format|
        format.html { redirect_to doctor_forms_url(:form_status => status, :action => 'draft', :form_type => params[:form_type], :form_id => params[:form_id]) }
        format.js   {}
        format.xml  { head :ok }
      end
    end
  end

end
