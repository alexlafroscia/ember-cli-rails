require "ember_cli/errors"
require "non-stupid-digest-assets"
require "ember_cli/html_page"
require "ember_cli/manifest"

module EmberCli
  class Sprockets
    class AssetPipelineError < BuildError; end
    def initialize(app)
      @app = app
    end

    def register!
      register_or_raise!(Rails.configuration.assets.precompile)
      register_or_raise!(NonStupidDigestAssets.whitelist)
    end

    def update_manifest!
      ember_manifest.merge_into!(rails_manifest)
    end

    def index_html(head:, body:)
      html_page = HtmlPage.new(
        content: app.index_file.read,
        head: head,
        body: body,
      )

      html_page.render
    end

    def javascript_assets
      if Rails.env.development?
        fallback_assets
      else
        [
          rails_assets.grep(%r{#{app.name}/assets/vendor(.*)\.js\z}).first,
          rails_assets.grep(%r{#{app.name}/assets/#{ember_app_name}(.*)\.js\z}).first,
        ]
      end
    end

    def stylesheet_assets
      if Rails.env.development?
        fallback_assets
      else
        [
          rails_assets.grep(%r{#{app.name}/assets/vendor(.*)\.css\z}).first,
          rails_assets.grep(%r{#{app.name}/assets/#{ember_app_name}(.*)\.css\z}).first,
        ]
      end
    end

    private

    attr_reader :app

    def fallback_assets
      ["#{app.name}/assets/vendor", "#{app.name}/assets/#{ember_app_name}"]
    end

    def ember_app_name
      @ember_app_name ||= app.options.fetch(:name) { package_json.fetch(:name) }
    end

    def package_json
      @package_json ||=
        JSON.parse(app.paths.package_json_file.read).with_indifferent_access
    end

    def ember_manifest
      @ember_manifest ||= Manifest.new(Rails.env, app.paths.manifest)
    end

    def rails_manifest
      Rails.application.assets_manifest
    end

    def rails_assets
      rails_manifest.assets.keys
    end

    def asset_matcher
      %r{\A#{app.name}/}
    end

    def register_or_raise!(precompiled_assets)
      if precompiled_assets.include?(asset_matcher)
        raise AssetPipelineError.new <<-MSG.strip_heredoc
          EmberCLI application #{app.name.inspect} already registered!
        MSG
      else
        precompiled_assets << asset_matcher
      end
    end
  end
end
