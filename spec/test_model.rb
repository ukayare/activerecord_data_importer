base = { "adapter" => "mysql2", "encoding" => "utf8", "pool" => 5, "username" => "root", "password" => "", "host" => "127.0.0.1" }

ActiveRecord::Base.configurations = {
  "test" => base.merge("database" => "test")
}

ActiveRecord::Base.establish_connection(:test)

class Char < ActiveRecord::Base
  include ActiverecordDataImporter
  has_many :char_arousals
  has_one :char_skill
end

class CharArousal < ActiveRecord::Base
  include ActiverecordDataImporter
end

class CharSkill < ActiveRecord::Base
  include ActiverecordDataImporter
  has_many :char_skill_effects
end

class CharSkillEffect < ActiveRecord::Base
  include ActiverecordDataImporter
end

class CharWithVersion < ActiveRecord::Base
  include ActiverecordDataImporter
  has_many :char_arousals
  has_one :char_skill
end

class Item < ActiveRecord::Base
  include ActiverecordDataImporter
  has_many :item_effects
end

class ItemEffect < ActiveRecord::Base
  include ActiverecordDataImporter
end
