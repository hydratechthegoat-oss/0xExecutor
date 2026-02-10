#pragma once
#include <stdint.h>

/**
 * 0xExecutor Offset Configuration
 * Targeted Version: version-80c7b8e578f241ff
 */

namespace Offsets {
    // --- Engine Singletons ---
    // The entry point to the entire engine heartbeat
    inline constexpr uintptr_t TaskScheduler = 0x7D33708;

    // --- DataModel & Context ---
    // Offset from TaskScheduler to find the DataModel
    inline constexpr uintptr_t DataModel = 0x118; 
    // Offset from HybridScriptsJob to find the ScriptContext
    inline constexpr uintptr_t ScriptContext = 0x3F0;

    // --- Luau VM Primitives ---
    // The pointer to the actual lua_State (the 'L' variable)
    inline constexpr uintptr_t LuaState = 0x108;
    // Security Identity (used to escalate script permissions to Level 8)
    inline constexpr uintptr_t Identity = 0x110;

    // --- Execution Methods ---
    // Replace these with the hex addresses found in the imtheo.lol TXT link
    inline constexpr uintptr_t luau_load = 0x1A2B3C4; 
    inline constexpr uintptr_t task_defer = 0x5D6E7F8;
    inline constexpr uintptr_t r_lua_pcall = 0x9A0B1C;

    // --- Visuals & ESP ---
    // Used for the advanced UI and world-to-screen projections
    inline constexpr uintptr_t VisualEngine = 0x775E8D0;
    inline constexpr uintptr_t ViewMatrix = 0x120;
}
