#include "pch.h"
#include "rpc_bridge.h"
#include "rpc_callbacks.h"
#include "discordRPC/discord_rpc.h"
#include <cstring>

#define DISCORD_REPLY_NO 0
#define DISCORD_REPLY_YES 1
#define DISCORD_REPLY_IGNORE 2

static int l_initialize(lua_State* L)
{
	const char* applicationId = luaL_checkstring(L, 1);

	luaL_checktype(L, 2, LUA_TBOOLEAN);
	int autoRegister = lua_toboolean(L, 2);

	const char* optionalSteamID = NULL;

	if (!lua_isnoneornil(L, 3)) optionalSteamID = luaL_checkstring(L, 3);

	DiscordEventHandlers handlers;
	std::memset(&handlers, 0, sizeof(handlers));

	handlers.ready = rpc_callbacks::onReady;
	handlers.disconnected = rpc_callbacks::onDisconnected;
	handlers.errored = rpc_callbacks::onErrored;
	handlers.joinGame = rpc_callbacks::onJoinGame;
	handlers.spectateGame = rpc_callbacks::onSpectateGame;
	handlers.joinRequest = rpc_callbacks::onJoinRequest;

	Discord_Initialize(applicationId, &handlers, autoRegister, optionalSteamID);

	return 0;
}

static int l_runCallbacks(lua_State* L)
{
	rpc_callbacks::setTlsLuaState(L);
	Discord_RunCallbacks();
	rpc_callbacks::setTlsLuaState(nullptr);
	return 0;
}

static int l_updatePresence(lua_State* L)
{
	if (!lua_istable(L, 1)) return luaL_error(L, "Expected a table as the first arugment!");

	DiscordRichPresence presence;
	std::memset(&presence, 0, sizeof(presence));

	presence.state = rpc_bridge::read_string_in_presence(L, "state");
	presence.details = rpc_bridge::read_string_in_presence(L, "details");
	presence.startTimestamp = rpc_bridge::read_int_in_presence(L, "startTimestamp");
	presence.endTimestamp = rpc_bridge::read_int_in_presence(L, "endTimestamp");
	presence.largeImageKey = rpc_bridge::read_string_in_presence(L, "largeImageKey");
	presence.largeImageText = rpc_bridge::read_string_in_presence(L, "largeImageText");
	presence.smallImageKey = rpc_bridge::read_string_in_presence(L, "smallImageKey");
	presence.smallImageText = rpc_bridge::read_string_in_presence(L, "smallImageText");
	presence.partyId = rpc_bridge::read_string_in_presence(L, "partyId");
	presence.partySize = (int)rpc_bridge::read_int_in_presence(L, "partySize");
	presence.partyMax = (int)rpc_bridge::read_int_in_presence(L, "partyMax");
	presence.matchSecret = rpc_bridge::read_string_in_presence(L, "matchSecret");
	presence.joinSecret = rpc_bridge::read_string_in_presence(L, "joinSecret");
	presence.spectateSecret = rpc_bridge::read_string_in_presence(L, "spectateSecret");
	presence.instance = (int8_t)rpc_bridge::read_int_in_presence(L, "instance");

	Discord_UpdatePresence(&presence);

	return 0;
}

static int l_clearPresence(lua_State* L)
{
	Discord_ClearPresence();
	return 0;
}

static int l_respond(lua_State* L)
{
	const char* userId = luaL_checkstring(L, 1);
	const char* replyString =  luaL_checkstring(L, 2);

	int reply;
	if (strcmp(replyString, "yes"))
		reply = DISCORD_REPLY_YES;
	else if (strcmp(replyString, "no"))
		reply = DISCORD_REPLY_NO;
	else if (strcmp(replyString, "ignore"))
		reply = DISCORD_REPLY_IGNORE;
	else
		return luaL_error(L, "Argument 'reply' must be one of these values: 'yes', 'no' or 'ignore'");

	Discord_Respond(userId, reply);

	return 0;
}

static int l_shutdown(lua_State* L)
{
	rpc_callbacks::freeCallbackRefs(L);
	Discord_Shutdown();
	return 0;
}

const char* rpc_bridge::read_string_in_presence(lua_State* L, const char* field)
{
	const char* stringField = nullptr;
	lua_getfield(L, 1, field);
	if (lua_isstring(L, -1)) stringField = lua_tostring(L, -1);
	lua_pop(L, 1);

	return stringField;
}

int64_t rpc_bridge::read_int_in_presence(lua_State* L, const char* field)
{
	int64_t intField = 0;
	lua_getfield(L, 1, field);
	if (lua_isinteger(L, -1)) intField = lua_tointeger(L, -1);
	lua_pop(L, 1);

	return intField;
}

static const luaL_Reg functions[] = {
	{"initialize", l_initialize},
	{"shutdown", l_shutdown},
	{"runCallbacks", l_runCallbacks},
	{"updatePresence", l_updatePresence},
	{"clearPresence", l_clearPresence},
	{"respond", l_respond},
	//Callbacks
	{"onReady", rpc_callbacks::l_onReady},
	{"onDisconnected", rpc_callbacks::l_onDisconnected},
	{"onErrored", rpc_callbacks::l_onErrored},
	{"onJoinGame", rpc_callbacks::l_onJoinGame},
	{"onSpectateGame", rpc_callbacks::l_onSpectateGame},
	{"onJoinRequest", rpc_callbacks::l_onJoinRequest},
	{NULL, NULL}
};

static void base(lua_State* L)
{
	lua_newtable(L);
	luaL_setfuncs(L, functions, 0);
	lua_pushstring(L, "_VERSION");
	lua_pushstring(L, DISCORDRPC_LUA_VERSION);
	lua_rawset(L, -3);
}

extern "C" __declspec(dllexport)
int luaopen_discord_rpc(lua_State* L)
{
	rpc_callbacks::initCallbackRefs();
	base(L);
	return 1;
}