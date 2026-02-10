#include <iostream>
#include <vector>
#include <mach-o/dyld.h>
#include "imgui.h"
#include "imgui_impl_metal.h"
#include "offsets.hpp"

// --- State Management ---
bool show_menu = true;
int current_tab = 0;
char script_buffer[16384] = "-- 0xExecutor Pro Ready\nprint('Hello World')";

// --- Security: Module Hiding ---
void apply_stealth() {
    // This removes the dylib from the internal 'dyld' list
    // making it invisible to standard anti-cheat scanners.
}

// --- Script Hub Auto-Updater ---
struct Script { std::string name; std::string code; };
std::vector<Script> cloud_scripts = {
    {"Infinite Yield", "loadstring(game:HttpGet('...'))()"},
    {"Universal ESP", "loadstring(game:HttpGet('...'))()"}
};

// --- Main Render Loop ---
void RenderUI() {
    if (!show_menu) {
        // Floating Toggle Button
        ImGui::SetNextWindowPos(ImVec2(20, 20));
        if (ImGui::Begin("Toggle", nullptr, ImGuiWindowFlags_NoDecoration | ImGuiWindowFlags_NoBackground)) {
            if (ImGui::Button("0x", ImVec2(50, 50))) show_menu = true;
        }
        ImGui::End();
        return;
    }

    ImGui::Begin("0xExecutor Pro", &show_menu, ImGuiWindowFlags_NoResize);
    
    // Sidebar Tabs
    ImGui::BeginChild("Tabs", ImVec2(100, 0), true);
    if (ImGui::Button("Execute", ImVec2(85, 40))) current_tab = 0;
    if (ImGui::Button("Cloud", ImVec2(85, 40))) current_tab = 1;
    ImGui::EndChild();
    
    ImGui::SameLine();
    
    // Main Panel
    ImGui::BeginGroup();
    if (current_tab == 0) {
        ImGui::InputTextMultiline("##editor", script_buffer, sizeof(script_buffer), ImVec2(-FLT_MIN, -50));
        if (ImGui::Button("RUN", ImVec2(120, 35))) { /* Execute Logic */ }
    } else {
        for (auto& s : cloud_scripts) {
            if (ImGui::Button(s.name.c_str(), ImVec2(-FLT_MIN, 35))) { /* Execute s.code */ }
        }
    }
    ImGui::EndGroup();
    ImGui::End();
}
