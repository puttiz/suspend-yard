class SpecResourcefulGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false, :skip_fixture => false

  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_underscore_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,     :controller_underscore_name
  alias_method  :controller_singular_name, :controller_file_name
  alias_method  :controller_table_name,    :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@name.pluralize)
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name = base_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions
      m.class_collisions controller_class_path, "#{controller_class_name}Controller", "#{controller_class_name}Helper"
      m.class_collisions class_path, "#{class_name}"

      # Controller, helper, views, and spec directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('spec/models', class_path))
      m.directory(File.join('spec/fixtures', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('spec/controllers', controller_class_path))
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('spec/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))
      m.directory(File.join('spec/views', controller_class_path, controller_file_name))

      # Model class, spec test, and fixtures.
      m.template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
      m.template 'model_spec.rb', File.join('spec/models', class_path, "#{file_name}_spec.rb")

      unless options[:skip_fixture]
        m.template 'fixtures.yml', File.join('spec/fixtures', "#{table_name}.yml")
      end

      # Views
      #%w{index show form}.each do |action|
        #m.template "#{action}.html.haml", File.join('app', 'views', controller_class_path, controller_file_name, "#{action}.html.haml")
        #m.template "#{action}.html.haml_spec.rb", File.join('spec', 'views', controller_class_path, controller_file_name, "#{action}.html.haml_spec.rb")
      #end

      # Helper
      #m.template 'helper.rb', File.join('app', 'helpers', controller_class_path, "#{controller_file_name}_helper.rb")
      #m.template 'helper_spec.rb', File.join('spec', 'helpers', controller_class_path, "#{controller_file_name}_helper_spec.rb")

      # Controller
      #m.template 'controller.rb', File.join('app', 'controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      #m.template 'controller_spec.rb', File.join('spec', 'controllers', controller_class_path, "#{controller_file_name}_controller_spec.rb")

      # Lib
      #m.template 'spec_helpers.rb', File.join('lib', 'spec_resourceful', 'spec_helpers.rb')

      # Routing
      #m.route_resources controller_file_name

      unless options[:skip_migration]
        m.migration_template(
          'migration.rb', 'db/migrate',
          :assigns => {
            :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}",
            :attributes => attributes
          },
          :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
        )
      end
    end
  end

protected
  def banner
    "Usage: #{$0} spec_resourceful ModelName [field:type, field:type]"
  end

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-timestamps",
            "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
    opt.on("--skip-migration",
            "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
    opt.on("--skip-fixture",
            "Don't generation a fixture file for this model") { |v| options[:skip_fixture] = v}
  end

  def model_name
    class_name.demodulize
  end
end
