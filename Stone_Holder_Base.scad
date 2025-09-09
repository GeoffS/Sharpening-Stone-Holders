// Copyright (C) 2025 Geoff Sobering

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program (see the LICENSE file in this directory).  
// If not, see <https://www.gnu.org/licenses/>.


include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

makeWithCutout = false;
makeWithoutCutout = false;

holderBaseCornerDia = 20;
holderBaseWallAdjXY = -2;

holderBaseX = stoneX + holderBaseCornerDia + 2*holderBaseWallAdjXY;
holderBaseY = stoneY + holderBaseCornerDia + 2*holderBaseWallAdjXY;
holderBaseZ = stoneSurfaceAboveDeskZ - stoneSurfaceAboveHolderZ;

echo(str("holderBaseX = ", holderBaseX));

holderUnderStoneZ = stoneSurfaceAboveDeskZ - stoneZ;

holderBaseCZ = 4;

holderBaseCornerOffsetX = holderBaseX/2 - holderBaseCornerDia/2;
holderBaseCornerOffsetY = holderBaseY/2 - holderBaseCornerDia/2;

cutoutCornerDia = 20;
cutoutOffsetX = 30;
cutoutOffsetY = 15;
cutoutCornerChamferDia = cutoutCornerDia + 5;
cutoutCornerCZ = 1;

module corner(dx=0, z=holderBaseZ)
{
	translate([holderBaseCornerOffsetX+dx, holderBaseCornerOffsetY, 0]) simpleChamferedCylinderDoubleEnded(d=holderBaseCornerDia, h=z, cz=holderBaseCZ);
}

module corners()
{
	doubleX() doubleY() corner();
}

module itemModule(doCutout)
{
	difference()
	{
		// Base exterior:
		union()
		{
			dx1 = -3;
			dx2 = dx1 - stoneSurfaceAboveHolderZ - 1.2;
			doubleX() hull() doubleY()
			{
				corner();
				corner(dx=dx1);
			}
			doubleX() hull() doubleY()
			{
				corner(dx=dx1);
				corner(dx=dx2, z=holderUnderStoneZ);
			}
			hull() doubleX() doubleY()
			{
				corner(dx=dx2, z=holderUnderStoneZ);
			}
		}

		if(doCutout)
		{
			// Base cut-out:
			//    Main cut-out:
			baseCutoutXform() tcy([0,0,-10], d=cutoutCornerDia, h=100);
			//    Bottom chamfer:
			baseCutoutXform()
				translate([0,0,-cutoutCornerChamferDia/2+cutoutCornerDia/2+cutoutCornerCZ]) cylinder(d2=0, d1=cutoutCornerChamferDia, h=cutoutCornerChamferDia/2);
			//    Top chamfer:
			baseCutoutXform()
				translate([0,0,holderUnderStoneZ-cutoutCornerDia/2-cutoutCornerCZ]) cylinder(d1=0, d2=cutoutCornerChamferDia, h=cutoutCornerChamferDia/2);
		}

		// Base interior:
		difference()
		{
			interiorExtraXY = 1;
			biX = stoneX + 2*interiorExtraXY;
			biY = stoneY + 2*interiorExtraXY;

			// Oversized interior rectangle:
			tcu([-biX/2, -biY/2, holderUnderStoneZ], [biX, biY, 100]);

			numbsDia = 8;
			// Interior nubs along X edges:
			nubs1OffsetX = stoneX/2 - 5;
			nubs1OffsetY = stoneY/2 + numbsDia/2;
			doubleX() doubleY() translate([nubs1OffsetX, nubs1OffsetY, 0]) simpleChamferedCylinder(d=numbsDia, h=holderBaseZ, cz=1);

			// Interior nubs along Y edges:
			nubs2OffsetX = stoneX/2 + numbsDia/2;
			nubs2OffsetY = 0;
			doubleX() doubleY() translate([nubs2OffsetX, nubs2OffsetY, 0]) simpleChamferedCylinder(d=numbsDia, h=holderBaseZ, cz=1);
		}
	}
}

module baseCutoutXform()
{
	hull() doubleX() doubleY() translate([stoneX/2-cutoutCornerDia/2-cutoutOffsetX, stoneY/2-cutoutCornerDia/2-cutoutOffsetY, 0]) children();
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule(doCutout=true);
	displayGhost() stoneGhost();
}
else
{
	if(makeWithCutout) itemModule(doCutout=true);
	if(makeWithoutCutout) itemModule(doCutout=false);
}

module stoneGhost()
{
	tcu([-stoneX/2, -stoneY/2, holderUnderStoneZ], [stoneX, stoneY, stoneZ]);
}
