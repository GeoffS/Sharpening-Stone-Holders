include <../OpenSCAD_Lib/MakeInclude.scad>

stoneX = 23;
stoneY = 160;
stoneZ = 7.8; // Nom. 0.3" TBB measure

lanskyRodCleananceZ = max(9.5-stoneZ, 0); //9.5; // OEM
lanskyRodExtensionY = 18;
lanskyRodHoleOffsetY = 7.7; //
echo(str("lanskyRodCleananceZ = ", lanskyRodCleananceZ));

lanskyRodHoleDia = 3.3;

gripZ = 10;

holderX = stoneX;
holderY = stoneY +lanskyRodExtensionY + 10;
holderZ = lanskyRodCleananceZ + gripZ;

module itemModule()
{
	difference()
    {
        union()
        {
            tcu([-holderX/2, -lanskyRodExtensionY, 0], [holderX, holderY, holderZ]);
        }

        // Cut for rod:
        tcu([-20, -40, holderZ-lanskyRodCleananceZ], 40);

        // Rod hole:
        tcy([0, -(lanskyRodExtensionY-lanskyRodHoleOffsetY), -30], d=lanskyRodHoleDia, h=100);
    }
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
