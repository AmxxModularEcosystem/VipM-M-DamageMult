#include <amxmodx>
#include <reapi>
#include <VipModular>

new const MODULE_NAME[] = "DamageMult";

public VipM_OnInitModules() {
    register_plugin("[VipM-M] Damage Mult", "1.0.0", "ArKaNeMaN");

    VipM_Modules_Register(MODULE_NAME);
    VipM_Modules_AddParams(MODULE_NAME,
        "Taken", ptFloat, false,
        "Given", ptFloat, false
    );
    VipM_Modules_RegisterEvent(MODULE_NAME, Module_OnActivated, "@OnModuleActivated");
}

@OnModuleActivated() {
    RegisterHookChain(RG_CBasePlayer_TakeDamage, "@OnPlayerTakeDamage", .post = false);
}

@OnPlayerFallDamage(const victimIndex, inflictorIndex, attackerIndex, Float:damage, damageType) {
    if (VipM_Modules_HasModule(MODULE_NAME, victimIndex)) {
        damage *= VipM_Params_GetFloat(VipM_Modules_GetParams(MODULE_NAME, victimIndex), "Given", 1.0);
    }

    if (VipM_Modules_HasModule(MODULE_NAME, attackerIndex)) {
        damage *= VipM_Params_GetFloat(VipM_Modules_GetParams(MODULE_NAME, attackerIndex), "Taken", 1.0);
    }

    SetHookChainArg(4, ATYPE_FLOAT, damage);
    return HC_SUPERCEDE;
}
