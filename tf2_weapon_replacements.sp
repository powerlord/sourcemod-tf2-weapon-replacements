// This file is just a template for stuff I intend to include in multiple plugins

#include <sourcemod>
#include <tf2>
#include <tf2items>
#include <tf2attributes>

#pragma semicolon 1

// This file storage is in a format that makes it easier for users to edit.
// We need to store it in a format that's easier to lookup by type

enum WeaponMode
{
	WeaponMode_ClassName,
	WeaponMode_ID,
}

enum ParseLevel
{
	ParseLevel_Top,
	ParseLevel_WeaponMode,
	ParseLevel_Item,
	ParseLevel_Attribute,
}

enum AttributeType
{
	AttributeType_OnAttack,				// Takes a function name
	AttributeType_OnHit,				// Takes a function name
	AttributeType_OnTakeDamage,			// Takes a function name
	AttributeType_Replace,				// Takes classname, index, quality, and level
	AttributeType_AddAttribute,			// Takes attribute name
	AttributeType_RemoveAttribute,		// Takes attribute name
}

new ParseLevel:g_ParseLevel = ParseLevel_Top;

new WeaponMode:g_WMode = WeaponMode_ClassName;

new String:g_CurrentWeapon[64];
new String:g_CurrrentType[64];

new Handle:attributeTracking[WeaponMode][AttributeType];

public Plugin:myinfo = 
{
	name = "TF2 Weapon Replacements",
	author = "Powerlord",
	description = "Test logic for weapon replacements",
	version = "1.0",
	url = ""
}

public OnPluginStart()
{
	for (new i = 0; i < AttributeType; ++i)
	{
		attributeTracking[i] = CreateArray();
	}
}

public OnConfigsExecuted()
{
	
}

public SMCResult:SectionStart(Handle:smc, const String:name[], bool:opt_quotes)
{
	switch (g_ParseLevel)
	{
		case ParseLevel_Top:
		{
			if (StrEqual(name, "By Classname", false))
			{
				g_WMode = WeaponMode_ClassName;
			}
			else if (StrEqual(name, "By Definition Index", false))
			{
				g_WMode = WeaponMode_ID;
			}
			g_ParseLevel = ParseLevel_WeaponMode;
		}
		
		case ParseLevel_WeaponMode:
		{
			strcopy(g_CurrentWeapon, sizeof(g_CurrentWeapon), name);
			g_ParseLevel = ParseLevel_Item;
		}
		
		case ParseLevel_Item:
		{
			strcopy(g_CurrentType, sizeof(g_CurrentType), name);
			g_ParseLevel = ParseLevel_Attribute;
		}
	}
	return SMCParse_Continue;
}

public SMCResult:SectionEnd(Handle:smc)
{
	switch (g_ParseLevel)
	{
		case ParseLevel_WeaponMode:
		{
			g_ParseLevel = ParseLevel_Top;
		}
		
		case ParseLevel_Item:
		{
			g_ParseLevel = ParseLevel_WeaponMode;
		}
		
		case ParseLevel_Attribute:
		{
			g_ParseLevel = ParseLevel_Item;
		}
	}
	
	return SMCParse_Continue;
}

public SMCResult:ReadKeyValue(Handle:smc, const String:key[], const String:value[], bool:key_quotes, bool:value_quotes)
{
}
