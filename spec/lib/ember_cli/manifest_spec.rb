require "ember_cli/manifest"

describe EmberCli::Manifest do
  describe "#merge_into!" do
    it "merges the manifest into the provided manifest" do
      manifest_file = create_json_file(
        "assets" => {
          "asset" => "path/to/asset.js",
        },
        "files" => {
          "file" => "path/to/file.js",
        },
      )
      manifest = EmberCli::Manifest.new("test", manifest_file.path)
      rails_manifest = OpenStruct.new(assets: {}, files: {})

      manifest.merge_into!(rails_manifest)

      expect(rails_manifest.assets).to eq("asset" => "path/to/asset.js")
      expect(rails_manifest.files).to eq("file" => "path/to/file.js")
    end
  end

  def create_json_file(json)
    tempfile = Tempfile.new("json")
    tempfile.write(JSON.dump(json))
    tempfile.close

    tempfile
  end
end
