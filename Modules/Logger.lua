-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2024 Bernhard Saumweber
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
-------------------------------------------------------------------------------

local PGF = select(2, ...)
local L = PGF.L
local C = PGF.C

C.LOG_LEVEL = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
}

local Logger = {
    level = C.LOG_LEVEL.ERROR
}

function Logger:Log(level, str)
    local timestamp = date('%H:%M:%S')
    print(string.format("%s PGF [%s] %s", timestamp, level, str))
end

function Logger:Debug(str)
    if self.level <= C.LOG_LEVEL.DEBUG then
        self:Log("D", str)
    end
end

function Logger:Info(str)
    if self.level <= C.LOG_LEVEL.INFO then
        self:Log("I", str)
    end
end

function Logger:Warn(str)
    if self.level <= C.LOG_LEVEL.WARN then
        self:Log("W", str)
    end
end

function Logger:Error(str)
    if self.level <= C.LOG_LEVEL.ERROR then
        self:Log("E", str)
    end
end

PGF.Logger = Logger

PremadeGroupsFilter.EnableDebugLogging = function ()
    Logger.level = C.LOG_LEVEL.DEBUG
end
