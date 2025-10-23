#pragma once
#include "lua.hpp"
#include <cstdint>

#define DISCORDRPC_LUA_VERSION "DiscordRPC Lua v1.0"

class rpc_bridge
{
public:
    static const char* read_string_in_presence(lua_State* L, const char* field);
    static int64_t read_int_in_presence(lua_State* L, const char* field);
};