module BehindTheName
  class Usages
    def self.from(filename)
      require 'yaml'
      (@usages ||= {})[filename] ||= new(YAML.load_file(File.join(__dir__, "#{filename}.yml")))
    end

    def initialize(yml)
      @data = yml
      generate_indices!
    end

    private def generate_indices!
      @by_code = @data.map { |datum| datum[:code].to_sym }
      @by_full = @data.group_by { |datum| datum[:full] }
    end

    def normalize(usage)
      return usage.to_sym if @by_code.include?(usage.to_sym)
      @by_full.fetch(usage).first.fetch(:code).to_sym
    end

    def include?(key)
      @by_code.include?(key) || @by_full.include?(key)
    end
  end
end
