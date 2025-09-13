include <../OpenSCAD_Lib/MakeInclude.scad>

stoneX = 23;
stoneY = 160;
stoneZ = 7.8; // Nom. 0.3" TBB measure

stoneRecessY = stoneY + 1;
stoneRecessZ = 3;
stoneRecessExtraY = 6;

lanskyRodExtensionY = 18;
lanskyRodHoleOffsetY = 7.7; //

lanskyRodHoleDia = 3.8;
lanskyRodHoleCtrY = -(lanskyRodExtensionY-lanskyRodHoleOffsetY);

rodRetainingScrewHoleDia = 2.9; // m3 tapped

gripX = 12;
gripZ = 12;
gripToStoneZ = 4;

stoneMountingSurfaceZ = gripZ + gripToStoneZ;

// The surface of the sharpening stone:
stoneSurfaceZ = stoneMountingSurfaceZ + stoneZ;

lanskyRodCleananceZ = max(9.5, stoneZ); // 9.5 = OEM
echo(str("lanskyRodCleananceZ = ", lanskyRodCleananceZ));

holderX = stoneX;
holderY = stoneRecessY +lanskyRodExtensionY + 2*stoneRecessExtraY;
holderZ = stoneMountingSurfaceZ + stoneRecessZ;
holderAtRodEndZ = stoneSurfaceZ - lanskyRodCleananceZ;

module itemModule()
{
	difference()
    {
        union()
        {
            tcu([-gripX/2, -lanskyRodExtensionY, 0], [gripX, holderY, gripZ]);
            dz = 1;
            translate([0, -lanskyRodExtensionY, gripZ-nothing]) hull()
            {
                tcu([-gripX/2, 0, 0], [gripX, holderY, nothing]);
                tcu([-holderX/2, 0, gripToStoneZ-dz], [holderX, holderY, nothing]);
            }
            tcu([-holderX/2, -lanskyRodExtensionY, gripZ+gripToStoneZ-dz], [holderX, holderY, gripToStoneZ-dz+nothing]);
            tcu([-holderX/2, -lanskyRodExtensionY, gripZ+gripToStoneZ-nothing], [holderX, holderY, stoneRecessZ++nothing]);
        }

        // Recess for stone:
        tcu([-200, stoneRecessExtraY, stoneMountingSurfaceZ], [400, stoneRecessY, 400]);

        // Cut for rod:
        slotX = lanskyRodHoleDia + 2;
        translate([0, lanskyRodHoleCtrY, holderAtRodEndZ]) hull()
        {
            tcy([0, 0, 0], d=slotX, h=100);
            tcy([0, -10, 0], d=slotX, h=100);
        }

        // Rod hole:
        tcy([0, lanskyRodHoleCtrY, -30], d=lanskyRodHoleDia, h=100);
        rodRetainingScrewHoleXform() tcy([0,0,-100], d=rodRetainingScrewHoleDia, h=100);
        // Chamfer:
        rodRetainingScrewHoleXform(y=-lanskyRodExtensionY-5+rodRetainingScrewHoleDia/2+1) translate([0,0,0]) cylinder(d1=10, d2=0, h=5);
    }
}

module rodRetainingScrewHoleXform(y=lanskyRodHoleCtrY+4)
{
    translate([0, y, holderAtRodEndZ/2]) rotate([-90,0,0]) children();
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
    // tcu([-200, -50, holderAtRodEndZ/2-d], 400);
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
    translate([0, stoneRecessExtraY+(stoneRecessY-stoneY)/2, stoneMountingSurfaceZ]) tcu([-stoneX/2, 0, 0], [stoneX, stoneY, stoneZ]);
}
