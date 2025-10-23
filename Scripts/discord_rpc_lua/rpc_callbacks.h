#pragma once
#include "lua.hpp"
#include "discordRPC/discord_rpc.h"

enum class callbacks {
    Ready,
    Disconnected,
    Errored,
    JoinGame,
    SpectateGame,
    JoinRequest,
    Count
};

class rpc_callbacks
{
public:
    //Trampolines
    static void onReady(const DiscordUser* user);
    static void onDisconnected(int errorCode, const char* message);
    static void onErrored(int errorCode, const char* message);
    static void onJoinGame(const char* joinSecret);
    static void onSpectateGame(const char* spectateSecret);
    static void onJoinRequest(const DiscordUser* user);

    static void setTlsLuaState(lua_State* newState);
    static void initCallbackRefs();
    static void freeCallbackRefs(lua_State* L);

    //Lua functions
    static int l_onReady(lua_State* L);
    static int l_onDisconnected(lua_State* L);
    static int l_onErrored(lua_State* L);
    static int l_onJoinGame(lua_State* L);
    static int l_onSpectateGame(lua_State* L);
    static int l_onJoinRequest(lua_State* L);

private:
    static thread_local lua_State* tls_L;
};