Version 3.1 of Pokemaker

Pokemaker is an app designed to aid development of my pokemon game that it is in development.
It will include the following features, that will be used for the game to allow interaction with a world:
 
Map visual design; 
Z-Index mapping;
Collision mapping;
Npc placement;
Event mapping;

TODO
Collision mapping is setup for saving and loading, just need to implement a way to populate visually the collision map
when collision icon is clicked or c pressed - allow placement of collision tiles - populate to loadedDragCollision
need to add loadedDragCollision for this though

Opacity change broken because lots of the same tile are being populated under the same square
Fix by only adding tiles when current tile != old tile where tile was placed
on save, run file sanitation function to remove duplicates
sublime potentially has a way to manually but quickly remove duplicates as a quick fix
to fix opacity errors in runtime - when changing to collision, sanitise the dragTiles list