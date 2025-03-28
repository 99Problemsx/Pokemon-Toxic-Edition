# rainefallFogs

New and improved, better terminology and easier to work with.

Map Overlays are per map and do not repeat. They are intended for use in place of fogs for lighting effects.
To use Map Overlays, add your lighting fog or whatever to Graphics/Fogs/Overlays (the folder will not exist, so create it)\
**IMPORTANT**: Your image should be HALF the size of your map, as it will be scaled up 2x by the script.

Fogs have been moved to Spriteset_Global, ensuring there will only ever be one fog in existence.
They work exactly the same as fogs otherwise.

Global Overlays are static images displayed above everything else, useful for vignette, static sunbeams etc
This is controlled with PBS, a property has been added to map_metadata.txt, OverlayName, which is the name of the image in Graphics/Fogs/Overlays to be displayed as a global overlay on that map.