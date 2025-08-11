include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

stoneX = 201;
stoneY = 75.6;
stoneZ = 17;

stoneSurfaceAboveDeskZ = 30;
stoneSurfaceAboveHolderZ = 8;

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
cutoutOffsetXY = 12;
cutoutCornerChamferDia = cutoutCornerDia + 5;
cutoutCornerCZ = 1;

module itemModule()
{
	difference()
	{
		// Base exterior:
		hull() doubleX() doubleY() translate([holderBaseCornerOffsetX, holderBaseCornerOffsetY, 0]) simpleChamferedCylinderDoubleEnded(d=holderBaseCornerDia, h=holderBaseZ, cz=holderBaseCZ);

		// Base cut-out:
		//    Main cut-out:
		baseCutoutXform() tcy([0,0,-10], d=cutoutCornerDia, h=100);
		//    Bottom chamfer:
		baseCutoutXform()
			translate([0,0,-cutoutCornerChamferDia/2+cutoutCornerDia/2+cutoutCornerCZ]) cylinder(d2=0, d1=cutoutCornerChamferDia, h=cutoutCornerChamferDia/2);
		//    Top chamfer:
		baseCutoutXform()
			translate([0,0,holderUnderStoneZ-cutoutCornerDia/2-cutoutCornerCZ]) cylinder(d1=0, d2=cutoutCornerChamferDia, h=cutoutCornerChamferDia/2);

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
			nubs1OffsetX = stoneX/2 - 30;
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
	hull() doubleX() doubleY() translate([stoneX/2-cutoutCornerDia/2-cutoutOffsetXY, stoneY/2-cutoutCornerDia/2-cutoutOffsetXY, 0]) children();
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
	displayGhost() stoneGhost();
}
else
{
	itemModule();
}

module stoneGhost()
{
	tcu([-stoneX/2, -stoneY/2, holderUnderStoneZ], [stoneX, stoneY, stoneZ]);
}
