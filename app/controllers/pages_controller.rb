class PagesController < ApplicationController
  before_filter :require_ssadmin_except_for_show

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find_by_stub(params[:stub]) || Page.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @page.to_xml }
    end
  end

end
