class ActiveYamlBase < ActiveYaml::Base
  include ActiveHash::Enum

  field :sort_order, default: 9999

  if Rails.env == 'test'
    set_root_path "#{Rails.root}/spec/fixtures"
  else
    set_root_path "#{Rails.root}/config"
  end

  class << self
    private

    def load_path(path)
      YAML.safe_load(ERB.new(File.read(path)).result)
    end
  end

  private

  def <=>(other)
    self.sort_order <=> other.sort_order
  end

end
