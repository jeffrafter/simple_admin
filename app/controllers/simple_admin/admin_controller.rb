require 'kaminari'
require 'ransack'

module SimpleAdmin
  class AdminController < ::ApplicationController
    before_filter :require_user
    before_filter :lookup_interface, :except => [:dashboard]
    before_filter :lookup_before, :except => [:dashboard]
    before_filter :lookup_resource, :only => [:show, :edit, :update, :destroy]
    before_filter :check_action, :except => [:dashboard]

    unloadable

    respond_to :json, :xml, :html, :except => :index

    helper SimpleAdmin::AdminHelper

    layout 'simple_admin'

    def index
      @collection = @interface.constant rescue nil
      if @collection
        @collection = @collection.search(clean_search_params(params)).result
        @collection = @collection.order("#{@interface.constant.table_name}.#{$1} #{$2}") if params[:order] && params[:order] =~ /^([\w\_\.]+)_(desc|asc)$/
        @collection = @collection.page(params[:page]).per(params[:per_page] || SimpleAdmin.default_per_page) if params[:format].blank? || params[:format] == 'html'
      end
      respond_to do |format|
        format.csv
        format.html
        format.xml { render :xml => @collection }
        format.json { render :json => @collection }
      end
    end

    def show
      respond_with(@resource)
    end

    def new
      @resource = @interface.constant.new
      respond_with(@resource)
    end

    def edit
      respond_with(@resource)
    end

    def create
      @resource = @interface.constant.new(params[@interface.member.to_sym])
      # respond_with will fail without explicit urls
      respond_to do |format|
        if @resource.save
          format.html { redirect_to send("simple_admin_#{@interface.member}_path", @resource), :notice => "#{@interface.member.titleize} was successfully created." }
          format.json { render :json => @resource, :status => :created, :location => send("simple_admin_#{@interface.member}_path", @resource) }
          format.xml { render :xml => @resource, :status => :created, :location => send("simple_admin_#{@interface.member}_path", @resource) }
        else
          format.html { render :action => "new" }
          format.json { render :json => @resource.errors, :status => :unprocessable_entity }
          format.xml { render :xml => @resource.errors, :status => :unprocessable_entity }
        end
      end
    end

    def update
      # respond_with will fail without explicit urls
      respond_to do |format|
        if @resource.update_attributes(params[@interface.member.to_sym])
          format.html { redirect_to send("simple_admin_#{@interface.member}_path", @resource), :notice => "#{@interface.member.titleize} was successfully updated." }
          format.json { head :ok }
          format.xml { head :ok }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @resource.errors, :status => :unprocessable_entity }
          format.xml { render :xml => @resource.errors, :status => :unprocessable_entity }
        end
      end
    end

    def destroy
      @resource.destroy
      # respond_with will fail without explicit urls
      respond_to do |format|
        format.html { redirect_to send("simple_admin_#{@interface.collection}_path") }
        format.json { head :ok }
        format.xml  { head :ok }
      end
    end

    def dashboard
    end

    protected

    def require_user
      send(SimpleAdmin.require_user_method) if SimpleAdmin.require_user_method
    end

    def lookup_interface
      SimpleAdmin.registered.each do |interface|
        @interface = interface if interface.collection == params[:interface]
      end
      # This should not be reached, routing should catch errors before this point
      raise UnknownAdminInterface.new("Could not find the interface for simple admin") unless @interface
    end

    def lookup_before
      @interface.before.each do |before|
        next unless before[:actions].include?(params[:action].to_sym)
        instance_eval(&before[:data])
      end
    end

    def lookup_resource
      @resource ||= @interface.constant.find(params[:id])
    end

    def clean_search_params(search_params)
      return {} unless search_params.is_a?(Hash)
      search_params = search_params.dup
      search_params.delete_if do |key, value|
        value == "" ||
        ["utf8", "scope", "commit", "action", "order", "interface", "controller", "format", "page", "per_page", "editing", "mode"].include?(key)
      end
      search_params
    end

    def check_action
      raise SimpleAdmin::ActionNotAllowed.new(params[:action]) unless @interface.actions.include?(params[:action].to_sym)
    end
  end
end
