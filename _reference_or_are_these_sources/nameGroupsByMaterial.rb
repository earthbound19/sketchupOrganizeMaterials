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
			sel.clear
			sel.add i
			part = sel[0].entities
				part.each do |j|
					if j.class == Sketchup::Face
						if j.material
						strMatName = j.material.name
						end
					end
				end
			i.name=strMatName
			end
		else
		end
	end
if( not file_loaded?("nameGroupsByMaterial.rb") )
    add_separator_to_menu("Plugins")
    UI.menu("Plugins").add_item("Name groups by material") { texture_groups }
end
#-----------------------------------------------------------------------------
file_loaded("nameGroupsByMaterial.rb")