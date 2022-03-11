class Currency < ActiveYaml::Base
  set_root_path "#{Rails.root}/config"
  set_filename 'currency'

end
