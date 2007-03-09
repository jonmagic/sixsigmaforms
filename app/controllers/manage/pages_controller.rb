class Manage::PagesController < ApplicationController
  layout 'admin'

  # GET /pages
  # GET /pages.xml
  def index #This is the ACTION 'index', accessed via /manage/pages, as opposed to the STUB 'index', accessed via /pages
    @pages = Page.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @pages.to_xml }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find_by_stub(params[:stub]) || Page.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @page.to_xml }
    end
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1;edit
  def edit
    @page = Page.find_by_stub(params[:stub]) || Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to manage_pages_url }
        format.xml  { head :created, :location => manage_page_url(@page) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors.to_xml }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find_by_stub(params[:stub]) || Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to manage_pages_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors.to_xml }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find_by_stub(params[:stub]) || Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to manage_pages_url }
      format.xml  { head :ok }
    end
  end
end
