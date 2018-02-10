# Copyright 2004, Rick Wilson 

# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

# Name :          groupByTexture.rb 1.0
# Description :   Explodes groups/components, regroups faces by material.
# Author :        Rick Wilson
# Usage :         1. Install into the plugins directory or into the 
#                    Plugins/examples directory and manually load from the ruby console "load 'examples/groupByTexture.rb'" 
#                 2. Run "Group by texture" from the Plugins menu.
# Date :          22.Dec.2004
# Type :          Tool
# History:        1.0 (22.Dec.2004) - first version

require 'sketchup.rb'

def group_by_texture_mod
	model=Sketchup.active_model
	ents=model.active_entities
	sel=model.selection
	comgrp=[]
	mats=model.materials
	mats.purge_unused
	matNames=[]
	mats.each {|m| matNames.push(m.name)}
	model.start_operation "Bomb"
	0.upto(ents.length) do |a|
#		FIND GROUPS AND COMPONENTS
		comgrp[comgrp.length] = ents[a] if ((ents[a].class == Sketchup::Group) || (ents[a].class == Sketchup::ComponentInstance))
	end
#		EXPLODE GROUP OR COMPONENT
	0.upto(comgrp.length-1) do |a|
		comgrp[a].explode
	end
	model.commit_operation
#		SORT BY MATERIAL
	model.start_operation "Group"
	noMat=[]
	matNames.each do |m|
		sel.clear
		ents.each do |ee|
			if ee.class == Sketchup::Face
				if ee.material
					sel.add(ee) if ee.material.name == m
				else
					noMat.push(ee)
				end
			end
		end
#			Adds all found faces of a given material to a new group
		(ents.add_group(sel))
#			THAT LINE PREVIOUSLY READ AS THE FOLLOWING:
#		(ents.add_group(sel)).name=m
#			- AND WAS SOMETIMES THROWING AN ERROR or not working properly
#			Only removing the .name=m off the end has solved that. -ahall
#			To solve what that was _supposed_ to do, I wrote a script,
#			nameGroupsByMaterial.rb.

	end
	sel.clear
#			Adds all found faces with the "default" material to one group	
	noMat.each {|nm| sel.add(nm)}
	(ents.add_group(sel)).name="<Default>" if sel.length>0

	model.commit_operation

end
if( not file_loaded?("groupByTexture.rb") )
    add_separator_to_menu("Plugins")
    UI.menu("Plugins").add_item("Group by texture mod") { group_by_texture_mod }
end
#-----------------------------------------------------------------------------
file_loaded("groupByTexture.rb")
