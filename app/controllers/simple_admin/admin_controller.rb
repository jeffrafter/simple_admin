require 'kaminari'

module SimpleAdmin
  class AdminController < ::ApplicationController

    unloadable

    respond_to :csv, :json, :xml, :html

    layout 'simple_admin'

    def index
      @collection = @interface.constant
      @collection = @collection.order("#{@interface.constant.table_name}.#{$1} #{$2}") if params[:order] && params[:order] =~ /^([\w\_\.]+)_(desc|asc)$/
      @collection = @collection.metasearch(clean_search_params(params))
      @collection = @collection.page(params[:page]).per(@per_page || SimpleAdmin.default_per_page)
      respond_with(@collection)
    end

    def show
      @resource = @interface.constant.find(params[:id])
      respond_with(@resource)
    end

    def new
      @resource = @interface.constant.new
      respond_with(@resource)
    end

    def edit
      @resource = @interface.constant.find(params[:id])
      respond_with(@resource)
     end

    def create
    end

    def update
    end

    def destroy
    end

    protected

    def clean_search_params(search_params)
      return {} unless search_params.is_a?(Hash)
      search_params = search_params.dup
      search_params.delete_if do |key, value|
        value == "" ||
        ["utf8", "scope", "commit", "action", "order", "interface", "controller", "format"].include?(key)
      end
      search_params
    end
  end
end
