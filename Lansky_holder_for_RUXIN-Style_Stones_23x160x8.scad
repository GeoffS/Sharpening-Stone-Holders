include <../OpenSCAD_Lib/MakeInclude.scad>

stoneX = 23;
stoneY = 160;
stoneZ = 7.8; // Nom. 0.3" TBB measure

stoneRecessY = stoneY + 1;
stoneRecessZ = 3;
stoneRecessExtraY = 6;

lanskyRodCleananceZ = max(9.5-stoneZ, 0); //9.5; // OEM
lanskyRodExtensionY = 18;
lanskyRodHoleOffsetY = 7.7; //
echo(str("lanskyRodCleananceZ = ", lanskyRodCleananceZ));

lanskyRodHoleDia = 3.3;
lanskyRodHoleCtrY = -(lanskyRodExtensionY-lanskyRodHoleOffsetY);

rodRetainingScrewHoleDia = 2.8; // m3 tapped

gripX = 12;
gripZ = 12;
gripToStoneZ = 2;

stoneSurfaceZ = gripZ + gripToStoneZ;

holderX = stoneX;
holderY = stoneRecessY +lanskyRodExtensionY + 2*stoneRecessExtraY;
holderZ = stoneSurfaceZ + stoneRecessZ;
holderAtRodEndZ = holderZ-lanskyRodCleananceZ;

module itemModule()
{
	difference()
    {
        union()
        {
            tcu([-gripX/2, -lanskyRodExtensionY, 0], [gripX, holderY, gripZ]);
            tcu([-holderX/2, -lanskyRodExtensionY, gripZ-nothing], [holderX, holderY, gripToStoneZ+nothing]);
            tcu([-holderX/2, -lanskyRodExtensionY, gripZ+gripToStoneZ-nothing], [holderX, holderY, stoneRecessZ++nothing]);
        }

        // Recess for stone:
        tcu([-200, stoneRecessExtraY, stoneSurfaceZ], [400, stoneRecessY, 400]);

        // Cut for rod:
        tcu([-20, -40, holderAtRodEndZ], 40);

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
    translate([0, stoneRecessExtraY+(stoneRecessY-stoneY)/2, stoneSurfaceZ]) tcu([-stoneX/2, 0, 0], [stoneX, stoneY, stoneZ]);
}
