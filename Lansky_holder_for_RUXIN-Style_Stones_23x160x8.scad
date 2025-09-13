include <../OpenSCAD_Lib/MakeInclude.scad>

stoneX = 23;
stoneY = 160;
stoneZ = 7.8; // Nom. 0.3" TBB measure

lanskyRodCleananceZ = max(9.5-stoneZ, 0); //9.5; // OEM
lanskyRodExtensionY = 18;
lanskyRodHoleOffsetY = 7.7; //
echo(str("lanskyRodCleananceZ = ", lanskyRodCleananceZ));

lanskyRodHoleDia = 3.3;
lanskyRodHoleCtrY = -(lanskyRodExtensionY-lanskyRodHoleOffsetY);

rodRetainingScrewHoleDia = 2.8; // m3 tapped

gripZ = 10;

holderX = stoneX;
holderY = stoneY +lanskyRodExtensionY + 10;
holderZ = lanskyRodCleananceZ + gripZ;
holderAtRodEndZ = holderZ-lanskyRodCleananceZ;

module itemModule()
{
	difference()
    {
        union()
        {
            tcu([-holderX/2, -lanskyRodExtensionY, 0], [holderX, holderY, holderZ]);
        }

        // Cut for rod:
        tcu([-20, -40, holderAtRodEndZ], 40);

        // Rod hole:
        tcy([0, lanskyRodHoleCtrY, -30], d=lanskyRodHoleDia, h=100);
        rodRetainingScrewHoleXform() tcy([0,0,-100], d=rodRetainingScrewHoleDia, h=100);
    }
}

module rodRetainingScrewHoleXform()
{
    translate([0, lanskyRodHoleCtrY+4, holderAtRodEndZ/2]) rotate([-90,0,0]) children();
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
    // tcu([-200, -50, holderAtRodEndZ/2-d], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
