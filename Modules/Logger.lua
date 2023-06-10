-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2022 Elotheon-Arthas-EU
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

C.LOG_PREFIX = "[PGF] "
C.LOG_LEVEL = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
}

local Logger = {
    level = C.LOG_LEVEL.DEBUG
}

function Logger:Debug(str)
    if self.level >= C.LOG_LEVEL.DEBUG then
        print(C.LOG_PREFIX .. str)
    end
end

function Logger:Info(str)
    if self.level >= C.LOG_LEVEL.INFO then
        print(C.LOG_PREFIX .. str)
    end
end

function Logger:Warn(str)
    if self.level >= C.LOG_LEVEL.WARN then
        print(C.LOG_PREFIX .. str)
    end
end

function Logger:Error(str)
    if self.level >= C.LOG_LEVEL.ERROR then
        print(C.LOG_PREFIX .. str)
    end
end

PGF.Logger = Logger
