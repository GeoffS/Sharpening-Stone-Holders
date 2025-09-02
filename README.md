# Sharpening-Stone-Holders

## General Information
These desgings are all created using OpenSCAD.
To compile them into STL (or other 3D formats), you will need:
* [OpenSCAD](https://openscad.orghttps://openscad.org) version >= 2025.05.14
* My [OpenSCAD library Version 1.0 or newer](https://github.com/GeoffS/OpenSCAD_Lib/releases/tag/v1.0) available at the same directory level as this project.
* Optional: python 3.x

In general you can compile any of these SCAD files into an STL via the command-line run fron the source-code directory:

`python ..\OpenSCAD_Lib\makeStls.py <SCAD File>`

This will create the STL(s) defined in the SCAD file in the directory above the source code.


## Sharpal 75x200mm (3x8 inches) holder
This is a very basic holder for 75x200mm stones.

The STL files in [Release 1.0]() were created with the command:

`python ..\OpenSCAD_Lib\makeStls.py .\Sharpnal_200x75_Diamond_Stone.scad`

![Photo of the Sharpal stone holder with a stone in it](README_Assets\20250901_185623~2.jpg)