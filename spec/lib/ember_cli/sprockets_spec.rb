require "ember_cli/sprockets"

describe EmberCli::Sprockets do
  describe "#update_manifest!" do
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

      sprockets.update_manifest!

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

  def create_manifest(json)
    tempfile = Tempfile.new("json")
    tempfile.write(JSON.dump(json))
    tempfile.close

    tempfile.path
  end
end
