module EmberCli
  class Engine < Rails::Engine
    initializer "ember-cli-rails.rendering" do
      require "ember_cli/ember_controller"
      require "ember_cli/route_helpers"
    end

    initializer "ember-cli-rails.enable" do
      EmberCli.enable! unless EmberCli.skip?
    end

    config.to_prepare do
      ActionController::Base.helper EmberRailsHelper
    end

    config.after_initialize do
      if defined?(ApplicationController)
        require "ember_cli/controller_extension"

        ApplicationController.include(EmberCli::ControllerExtension)
      end
    end
  end
end
