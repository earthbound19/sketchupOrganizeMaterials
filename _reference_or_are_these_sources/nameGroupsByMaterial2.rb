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
#

	require 'sketchup.rb'

											#n = 0
	model=Sketchup.active_model
	ents=model.entities
	sel = model.selection
	strMatName = "<Default>"
	strLastMatName = "initVoid"
	multiMat = 0
	
	ents.each do |i|
		if i.class == Sketchup::Group
			testStr=i.name
			if testStr == "<Default>"
											#Do nothing
			else
											str = "Group name is: " << i.name
											UI.messagebox str
			sel.clear
			sel.add i
			part = sel[0].entities
				part.each do |j|
					if j.class == Sketchup::Face
											#n = n + 1
						if j.material
						strMatName = j.material.name
							if strMatName != strLastMatName and strLastMatName != "initVoid"
							multiMat = 1
											str = "Multiple materials found in object."
											UI.messagebox str
											strLastMatName = "initVoid"
							end
											#str = "Material " << strMatName << " found on face."
											#UI.messagebox str
						strLastMatName = strMatName
						end
					end
				end
											#str = "number of faces in selection is " << n.to_s()
											#UI.messagebox str
					if multiMat == 1
						strNameByGroup = "_Multi_ " << strMatName
					else
						strNameByGroup = strMatName
					end
											#str = "Changing group name to match material " << strMatName << ".."
											#UI.messagebox str
				i.name=strNameByGroup
				str = "current mat: " << strMatName
				UI.messagebox str
				str = "last mat: " << strLastMatName
				UI.messagebox str
											#n = 0

			end
		else
											#nothing, just putting this else here to help keep indents clearer
											#UI.messagebox "Not group, skipping"
		end
	end
if( not file_loaded?("nameGroupsByMaterial.rb") )
    add_separator_to_menu("Plugins")
    UI.menu("Plugins").add_item("Name groups by material") { texture_groups }
end
#-----------------------------------------------------------------------------
file_loaded("nameGroupsByMaterial.rb")