require "ember_cli/sprockets"

describe EmberCli::Sprockets do
  describe "#update!" do
    it "merges the EmberCLI-generated manifest with Sprockets' manifest" do
      rails_manifest = create_manifest("assets" => {}, "files" => {})
      ember_manifest = create_manifest(
        "assets" => {
          "foo.js" => "foo.js",
        },
        "files" => {
          "foo.js" => "foo.js",
        }
      )
      path_set = double(manifest: ember_manifest)
      app = double(paths: path_set)
      sprockets = EmberCli::Sprockets.new(app)

      sprockets.update!

      expect(rails_manifest).to eq(
        "assets" => {
          "foo.js" => "foo.js",
        },
        "files" => {
          "foo.js" => "foo.js",
        }
      )
    end
  end
end
