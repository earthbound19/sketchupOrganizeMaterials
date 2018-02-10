#2010 by Alex Hall
#www.openhatch.net
#Free for any use and any purpose

# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

# To use, copy into the Sketchup plugins directory, or plugins/examples (to manually
# load from the ruby console with "load 'examples/nameGroupsByMaterial.rb'"), then
# run Sketchup, and from the Plugins menu, run "Name groups by material"
#
# A limitation of this script is that it will name a group by the last material it
# has selected in the group (if the group has different materials on different faces).


	require 'sketchup.rb'

def name_groups_by_material
	model=Sketchup.active_model
	ents=model.entities
	sel = model.selection
	mats = model.materials
	mats.purge_unused
	
	ents.each do |i|
		if i.is_a?(Sketchup::Group)
			strGroupName = ""
			strGroupMatName = ""
											#matSearchCount = 0
			faceMatNames=[]
#			if testStr == "<Default>"
#				UI.messagebox "Skipping checks in group; Default material found."
#			else
											#str = "Group name is: " << i.name
											#UI.messagebox str
			sel.clear
			sel.add i
			part = sel[0].entities
				part.each do |j|
					if j.class == Sketchup::Face
											#IN THE CASE OF A FRONT FACE,
											#Add material name to an array
						if j.material
							faceMatNames.push(j.material.name)
											#IF IT DOESN'T HAVE A MATERIAL, MARK IT DEFAULT
							else
								faceMatNames.push("<Default>")
											#UI.messagebox "Default material found in object."
						end
											#OR IN THE CASE OF A BACK FACE,
											#CHECK BACK FACE AGAINST PREVIOUSLY CHECKED MATERIAL
						if j.back_material
							faceMatNames.push(j.back_material.name)
											#IF IT DOESN'T HAVE A MATERIAL, MARK IT DEFAULT
							else
								faceMatNames.push("<Default>")
											#UI.messagebox "Default material found in object."
						end
					end
				end
											#Remove duplicate material names from array of found material names;
											#Then the number of materials left in the array will be the number of
											#materials in the object.. probably will not exceed 3 the way I'm using this.
				faceMatNames.uniq!
				if faceMatNames.include?("<Default>")
					faceMatNames.delete("<Default>")
					faceMatNames.unshift("<Default>")
				end
				count = 0
				faceMatNames.each do |check|
					count = count + 1
					if count > 1
						strGroupMatName = strGroupMatName << " + " << check
						else
						strGroupMatName = check
					end
				end
				strGroupName = strGroupName << strGroupMatName
			i.name=strGroupName
			model.commit_operation
		else
		end
	end
end


if( not file_loaded?("nameGroupsByMaterial.rb") )
    add_separator_to_menu("Plugins")
    UI.menu("Plugins").add_item("Name groups by material") { name_groups_by_material }
end
#-----------------------------------------------------------------------------
file_loaded("nameGroupsByMaterial.rb")