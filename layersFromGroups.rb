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

#COPIED DIRECTLY FROM PutOnLayer.rb
def putCurrentRecursion(ents,clayer)
	etype = ents.typename
	case etype
		when "Face"
			ents.layer=clayer if ents.layer!=clayer #if layer needs to be changed		
		when "Edge"
			ents.layer=clayer if ents.layer!=clayer #if layer needs to be changed				
		when "Group"				
			ents.layer=clayer if ents.layer!=clayer
			ents.entities.each do |ent|
				putCurrentRecursion(ent,clayer) #recursion happens here
			end
	 	when "ComponentInstance"
			ents.layer=clayer if ents.layer!=clayer
			begin
				ents.definition.entities.each do |ent|
					putCurrentRecursion(ent,clayer) #recursion happens here
				end
			rescue => err
				puts "EXCEPTION: #{err}"
			end
		else
			begin
				old = ents.layer.name.to_s
				new = clayer.name.to_s
				ents.layer=clayer if ents.layer!=clayer
				puts "Old: " + old + ", New: " + new
			rescue => err
				puts "EXCEPTION: #{err}"
			end
	end
end

def layers_from_groups
model=Sketchup.active_model
ents=model.entities
layers=model.layers
	ents.each do |i|
		if i.class == Sketchup::Group
									#UI.messagebox "object " << i.name << " found; creating layer of same name.."
		new_layer = layers.add i.name
			n = 0
			layerNames=[]
			layers.each do |j|
				layerNames.push(layers[n].name)
				n = n + 1
									#UI.messagebox "n is " << n.to_s()
			end
									#UI.messagebox "new layer name is" << i.name
									#bool = layerNames.include?(i.name)
									#UI.messagebox "boolean operation returned " << bool.to_s()
									#UI.messagebox "value of indNum is " << indNum.to_s()
									#UI.messagebox "Layer " << layers[indNum].name << " found."
			indNum = layerNames.index(i.name)
									#UI.messagebox "Found layer name at index " << indNum.to_s() << ", name " << layers[indNum].name << "; attempting to move entity to said layer.."
			putCurrentRecursion(i,layers[indNum].name)
		model.commit_operation
		end
	end

end

#n = 0
#layers.each do |j|
#UI.messagebox "layer " << layers[n].name << " found."
#n = n + 1
#end

if( not file_loaded?("layersFromGroups.rb") )
    add_separator_to_menu("Plugins")
    UI.menu("Plugins").add_item("Groups to layers by name") { layers_from_groups }
end