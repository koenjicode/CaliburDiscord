#include "pch.h"
#include "utils.h"
#include <cstdio>

void utils::printError(const char* error)
{
	HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);

	CONSOLE_SCREEN_BUFFER_INFO consoleInfo;
	GetConsoleScreenBufferInfo(hConsole, &consoleInfo);
	WORD ogColour = consoleInfo.wAttributes;

	SetConsoleTextAttribute(hConsole, FOREGROUND_RED | FOREGROUND_INTENSITY);

	printf("[DiscordRPC Lua] Encountered an error: %s\n", error);

	SetConsoleTextAttribute(hConsole, ogColour);
}