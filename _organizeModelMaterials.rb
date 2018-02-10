require 'sketchup.rb'
require 'bomb.rb'
require 'groupByTextureMod.rb'
require 'nameGroupsByMaterial.rb'
require 'layersFromGroups.rb'

def organize_model_materials
bomb_groups()
group_by_texture_mod()
name_groups_by_material()
layers_from_groups()
end

if( not file_loaded?("_organizeModelMaterials.rb") )
    add_separator_to_menu("Plugins")
    UI.menu("Plugins").add_item("[organize model materials]") { organize_model_materials }
end