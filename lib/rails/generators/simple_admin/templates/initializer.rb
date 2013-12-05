# You can use this file to setup all of your simple_admin
# configuration defaults. If you change this file, you may
# need to restart your Rails environment

SimpleAdmin.setup do |config|

  # The +require_user_method+ setting allows you to specify which
  # controller method should be called before rendering any admin
  # pages. There is no default for this method. If it is not
  # present then simple_admin will not do any admin verification
  # prior to performing its controller actions.
  #
  # It is possible to check for admin status using application level
  # before filters or even using the +before+ block within each
  # individual admin interface registration.
  #
  # To set this, specify the controller method you want called as a
  # symbol:
  #
  # config.require_user_method = :require_admin


  # The +current_user_method+ is used by simple_admin to determine if
  # there is a logged in user. There is no default for this property.
  # If it is not present, no logged in user method will be checked and
  # user information will not be displayed in the header of admin forms.
  #
  # To set this, specify the controller method you want called as a
  # symbol:
  #
  # config.current_user_method = :current_user


  # The +current_user_name_method+ is used by simple_admin to access the
  # display name of the currently logged in user. There is no default for
  # this property. If it is not present, any logged in user name will
  # not be displayed in the header of admin forms.
  #
  # To set this, specify the controller method you want called as a
  # symbol:
  #
  # config.current_user_name_method = :current_user_name


  # The +site_title+ is displayed in the header of admin pages. If empty
  # this value defaults to +Rails.application.class.parent_name.titleize+:
  #
  # config.site_title = "My Website"


  # The +default_per_page+ value allows you to control how many results
  # appear on admin index pages. This value is fed into kaminari and is
  # defaulted to 25 if not present:
  #
  # config.default_per_page = 25


  # The +form_for_helper+ defaults to the +:semantic_form_for+ helper
  # from formtastic. If you want to use another engine, like +simple_form+
  # you can change this property and the gem requirements. Note that the
  # default styling from active_admin relies on formtastic output.
  #
  # config.form_for_helper = :semantic_form_for


  # The +stylesheet+ and +javascript+ properties are used within the admin
  # layout and are defaulted to the active_admin styles and scripts. You
  # may want to override these styles, or simply use the asset pipeline
  # instead of installing them to your public folder. These properties allow
  # you to manage where the assets are stored (either within the default
  # pipeline or no). By default, SimpleAdmin assumes you have run the
  # asset generator (rails g simple_admin:assets) and that these files
  # live within your public folder:
  #
  # config.stylesheet = "/stylesheets/simple_admin/active_admin.css"
  # config.javascript = "/javascripts/simple_admin/active_admin.js"

end
