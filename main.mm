#include <vector>
#include <string>
#include <algorithm>
#include "imgui.h"
#include "offsets.hpp"

// --- Advanced State Management ---
struct EditorTab { std::string name; char buffer[32768]; };
std::vector<EditorTab> tabs = { {"Tab 1", "-- 0xPro Editor\nprint('Ready')"} };
int active_tab_idx = 0;
char search_query[256] = "";

// --- Advanced Script Hub (Searchable) ---
struct CloudScript { std::string name; std::string author; std::string code; };
std::vector<CloudScript> scripts = {
    {"Infinite Yield", "Edge", "loadstring(game:HttpGet('...'))()"},
    {"Fly Hub", "Admin", "loadstring(game:HttpGet('...'))()"}
};

void Render0xPro() {
    ImGui::Begin("0xExecutor Ultra", nullptr, ImGuiWindowFlags_NoCollapse);

    // TOP BAR: Tab Management
    if (ImGui::Button("+ New Tab")) {
        tabs.push_back({"New Tab", ""});
    }
    ImGui::SameLine();
    for(int i = 0; i < (int)tabs.size(); i++) {
        if (i > 0) ImGui::SameLine();
        if (ImGui::Selectable(tabs[i].name.c_str(), active_tab_idx == i, 0, ImVec2(80, 0))) active_tab_idx = i;
    }

    ImGui::Separator();

    // SIDEBAR: Searchable Script Hub
    ImGui::BeginChild("Hub", ImVec2(150, 0), true);
    ImGui::InputText("Search", search_query, sizeof(search_query));
    ImGui::Separator();
    
    for (auto& s : scripts) {
        std::string name_lower = s.name;
        std::transform(name_lower.begin(), name_lower.end(), name_lower.begin(), ::tolower);
        if (name_lower.find(search_query) != std::string::npos) {
            if (ImGui::Selectable(s.name.c_str())) {
                strncpy(tabs[active_tab_idx].buffer, s.code.c_str(), 32768);
            }
            if (ImGui::IsItemHovered()) ImGui::SetTooltip("By: %s", s.author.c_str());
        }
    }
    ImGui::EndChild();

    ImGui::SameLine();

    // MAIN: Editor & Console
    ImGui::BeginGroup();
    ImGui::InputTextMultiline("##editor", tabs[active_tab_idx].buffer, 32768, ImVec2(-FLT_MIN, -40));
    if (ImGui::Button("EXECUTE", ImVec2(120, 30))) { /* Execution logic */ }
    ImGui::EndGroup();

    ImGui::End();
}
