require "sprockets"

module EmberCli
  class Manifest
    def initialize(environment, path)
      @manifest = ::Sprockets::Manifest.new(environment, path)
    end

    def merge_into!(other)
      other.assets.merge!(@manifest.assets)
      other.files.merge!(@manifest.files)
    end
  end
end
