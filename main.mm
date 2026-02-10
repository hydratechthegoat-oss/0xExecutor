#include <iostream>
#include <vector>
#include <string>
#include <mach-o/dyld.h>
#include "imgui.h" // The compiler will find this now thanks to the -I flag
#include "imgui_impl_metal.h"
#include "offsets.hpp"

// --- 0xExecutor Pro State ---
bool show_menu = true;
int active_tab = 0;
char script_input[16384] = "-- 0xExecutor v1.0\nprint('System Online')";

// --- Backend Execution ---
void execute(const char* code) {
    uintptr_t base = (uintptr_t)_dyld_get_image_header(0);
    uintptr_t scheduler = *(uintptr_t*)(base + Offsets::TaskScheduler);
    if (!scheduler) return;

    uintptr_t sc = *(uintptr_t*)(scheduler + Offsets::ScriptContext);
    uintptr_t L = *(uintptr_t*)(sc + Offsets::LuaState);

    // Bypassing security levels
    *(int*)(sc + Offsets::Identity) = 8;

    auto r_load = (void(*)(uintptr_t, const char*))(base + Offsets::luau_load);
    r_load(L, code);
}

// --- Main UI Render ---
void Render0x() {
    if (!show_menu) {
        ImGui::SetNextWindowPos(ImVec2(20, 20));
        if (ImGui::Begin("Toggle", nullptr, ImGuiWindowFlags_NoDecoration | ImGuiWindowFlags_NoBackground)) {
            if (ImGui::Button("0x", ImVec2(50, 50))) show_menu = true;
        }
        ImGui::End();
        return;
    }

    ImGui::SetNextWindowSize(ImVec2(550, 380), ImGuiCond_FirstUseEver);
    ImGui::Begin("0xExecutor Pro", &show_menu, ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoTitleBar);

    // Sidebar
    ImGui::BeginChild("Sidebar", ImVec2(110, 0), true);
    if (ImGui::Button("Execute", ImVec2(95, 40))) active_tab = 0;
    if (ImGui::Button("Cloud", ImVec2(95, 40))) active_tab = 1;
    ImGui::SetCursorPosY(ImGui::GetWindowHeight() - 50);
    if (ImGui::Button("HIDE", ImVec2(95, 40))) show_menu = false;
    ImGui::EndChild();

    ImGui::SameLine();

    // Editor Panel
    ImGui::BeginGroup();
    if (active_tab == 0) {
        ImGui::InputTextMultiline("##editor", script_input, sizeof(script_input), ImVec2(-FLT_MIN, -55));
        if (ImGui::Button("RUN SCRIPT", ImVec2(150, 40))) execute(script_input);
    } else {
        ImGui::Text("Cloud Script Hub");
        if (ImGui::Button("Infinite Yield", ImVec2(-FLT_MIN, 40))) execute("loadstring(game:HttpGet('...'))()");
    }
    ImGui::EndGroup();
    ImGui::End();
}
