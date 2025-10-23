#include "pch.h"
#include "rpc_callbacks.h"
#include "rpc_bridge.h"
#include "utils.h"
#include <cstring>

thread_local lua_State* rpc_callbacks::tls_L = nullptr;
static int callback_refs[(int)callbacks::Count] = {};

void rpc_callbacks::initCallbackRefs()
{
	for (int i = 0; i < (int)callbacks::Count; i++)
	{
		callback_refs[i] = LUA_NOREF;
	}
}

void rpc_callbacks::freeCallbackRefs(lua_State* L)
{
	for (int i = 0; i < (int)callbacks::Count; i++)
	{
		if (callback_refs[i] != LUA_NOREF)
		{
			luaL_unref(L, LUA_REGISTRYINDEX, callback_refs[i]);
			callback_refs[i] = LUA_NOREF;
		}
	}
}

void rpc_callbacks::setTlsLuaState(lua_State* newState) { tls_L = newState; }
static void setCallbackRef(lua_State* L, callbacks cb)
{
	luaL_checktype(L, 1, LUA_TFUNCTION);
	int& ref = callback_refs[(int)cb];
	if (ref != LUA_NOREF) luaL_unref(L, LUA_REGISTRYINDEX, ref);
	lua_pushvalue(L, 1);
	ref = luaL_ref(L, LUA_REGISTRYINDEX);
}

void rpc_callbacks::onReady(const DiscordUser* user)
{
	lua_State* L = tls_L;
	int ref = callback_refs[(int)callbacks::Ready];
	if (!L || ref == LUA_NOREF) return;

	int stackTop = lua_gettop(L);
	lua_rawgeti(L, LUA_REGISTRYINDEX, ref);

	lua_pushstring(L, user->userId);
	lua_pushstring(L, user->username);
	lua_pushstring(L, user->discriminator);
	lua_pushstring(L, user->avatar);

	if (lua_pcall(L, 4, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(L, -1);
		utils::printError(error);
		lua_pop(L, 1);
	}
	lua_settop(L, stackTop);
}

void rpc_callbacks::onDisconnected(int errorCode, const char* message)
{
	lua_State* L = tls_L;
	int ref = callback_refs[(int)callbacks::Disconnected];
	if (!L || ref == LUA_NOREF) return;

	int stackTop = lua_gettop(L);
	lua_rawgeti(L, LUA_REGISTRYINDEX, ref);

	lua_pushinteger(L, errorCode);
	lua_pushstring(L, message);

	if (lua_pcall(L, 2, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(L, -1);
		utils::printError(error);
		lua_pop(L, 1);
	}
	lua_settop(L, stackTop);
}

void rpc_callbacks::onErrored(int errorCode, const char* message)
{
	lua_State* L = tls_L;
	int ref = callback_refs[(int)callbacks::Errored];
	if (!L || ref == LUA_NOREF) return;

	int stackTop = lua_gettop(L);
	lua_rawgeti(L, LUA_REGISTRYINDEX, ref);

	lua_pushinteger(L, errorCode);
	lua_pushstring(L, message);

	if (lua_pcall(L, 2, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(L, -1);
		utils::printError(error);
		lua_pop(L, 1);
	}
	lua_settop(L, stackTop);
}

void rpc_callbacks::onJoinGame(const char* joinSecret)
{
	lua_State* L = tls_L;
	int ref = callback_refs[(int)callbacks::JoinGame];
	if (!L || ref == LUA_NOREF) return;

	int stackTop = lua_gettop(L);
	lua_rawgeti(L, LUA_REGISTRYINDEX, ref);

	lua_pushstring(L, joinSecret);

	if (lua_pcall(L, 1, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(L, -1);
		utils::printError(error);
		lua_pop(L, 1);
	}
	lua_settop(L, stackTop);
}

void rpc_callbacks::onSpectateGame(const char* spectateSecret)
{
	lua_State* L = tls_L;
	int ref = callback_refs[(int)callbacks::SpectateGame];
	if (!L || ref == LUA_NOREF) return;

	int stackTop = lua_gettop(L);
	lua_rawgeti(L, LUA_REGISTRYINDEX, ref);

	lua_pushstring(L, spectateSecret);

	if (lua_pcall(L, 1, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(L, -1);
		utils::printError(error);
		lua_pop(L, 1);
	}
	lua_settop(L, stackTop);
}

void rpc_callbacks::onJoinRequest(const DiscordUser* user)
{
	lua_State* L = tls_L;
	int ref = callback_refs[(int)callbacks::JoinRequest];
	if (!L || ref == LUA_NOREF) return;

	int stackTop = lua_gettop(L);
	lua_rawgeti(L, LUA_REGISTRYINDEX, ref);

	lua_pushstring(L, user->userId);
	lua_pushstring(L, user->username);
	lua_pushstring(L, user->discriminator);
	lua_pushstring(L, user->avatar);

	if (lua_pcall(L, 4, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(L, -1);
		utils::printError(error);
		lua_pop(L, 1);
	}
	lua_settop(L, stackTop);
}

int rpc_callbacks::l_onReady(lua_State* L) { setCallbackRef(L, callbacks::Ready);	return 0; }
int rpc_callbacks::l_onDisconnected(lua_State* L) { setCallbackRef(L, callbacks::Disconnected);	return 0; }
int rpc_callbacks::l_onErrored(lua_State* L) { setCallbackRef(L, callbacks::Errored);	return 0; }
int rpc_callbacks::l_onJoinGame(lua_State* L) { setCallbackRef(L, callbacks::JoinGame);	return 0; }
int rpc_callbacks::l_onSpectateGame(lua_State* L) { setCallbackRef(L, callbacks::SpectateGame);	return 0; }
int rpc_callbacks::l_onJoinRequest(lua_State* L) { setCallbackRef(L, callbacks::JoinRequest);	return 0; }