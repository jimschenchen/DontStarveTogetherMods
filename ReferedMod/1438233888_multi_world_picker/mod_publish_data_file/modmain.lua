local _G = GLOBAL
local STRINGS = _G.STRINGS
-- _G.CHEATS_ENABLED = true

local lang = GetModConfigData("language")
local auto_balancing = GetModConfigData("auto_balancing") == true
local no_bat = GetModConfigData("no_bat") == true
local world_prompt = GetModConfigData("world_prompt") == true
local migration_postern = GetModConfigData("migration_postern") == true
local ignore_sinkholes = GetModConfigData("ignore_sinkholes") == true
local say_dest = GetModConfigData("say_dest") == true

local _config = {}
_config.world_name = GetModConfigData("world_name") or {}
_config.population_limit = GetModConfigData("population_limit") or {}
_config.extra_worlds = {}
for _, v in ipairs(GetModConfigData("extra_worlds") or {}) do
    _config.extra_worlds[v] = true
end
_config.invisible_worlds = {}
for _, v in ipairs(GetModConfigData("invisible_worlds") or {}) do
    _config.invisible_worlds[v] = true
end

local PickWorldScreen = _G.require "screens/pickworldscreen"

Assets = {
    Asset("ATLAS", "images/wpicker.xml"),
    Asset("IMAGE", "images/wpicker.tex")
}

--语言设置，问题：不能同步到客户机？
if lang == "cht" then
    modimport("scripts/strings_cht.lua")
elseif lang == "chs" then
    modimport("scripts/strings_chs.lua")
elseif lang == "en" then
    modimport("scripts/strings.lua")
else
    local timeZone = (_G.os.time() - _G.os.time(_G.os.date("!*t", _G.os.time()))) / 3600
    if timeZone == 8 then
        local mlang = _G.LanguageTranslator.defaultlang
        if mlang == "cht" or mlang == "TW" then
            modimport("scripts/strings_cht.lua")
        else
            modimport("scripts/strings_chs.lua")
        end
    else
        modimport("scripts/strings.lua")
    end
end

--添加RPC处理
AddModRPCHandler(
    --控件可见性(关闭面板)
    "multiworldpicker",
    "worldpickervisibleRPC",
    function(player, wannaopen)
        -- if player == nil then
        --     return
        -- end
        -- print("[MWP] RPC worldpicker VISIBLE handling")
        if wannaopen and not player.player_classified.worldpickervisible:value() then
            --code to open the HUD
            --客户机开启面板只需要调用 SendModRPCToServer(MOD_RPC["multiworldpicker"]["worldpickervisibleRPC"], true)
            --

            if _G.TheWorld.ShardList == nil or #_G.TheWorld.ShardList < 2 then
                print("[MWP] Cannot open selector panel without enough shards!", player)
                return
            end

            --限制同一玩家连续开启控件间隔时间3秒
            if player.mwp_last_show_wp == nil or (_G.os.time() - player.mwp_last_show_wp) > 3 then
                player.mwp_last_show_wp = _G.os.time()
                --传入的portalid为0，一般情况下，玩家会传送到目标世界的大门处
                player.player_classified:ShowWorldPickerPopup(true, 0)
            elseif player.components and player.components.talker then
                player.components.talker:Say(STRINGS.MWP.WHERE_TO_GO)
            end
        else
            player.player_classified.worldpickervisible:set_local(false)
            player.player_classified._worldpickerportalid = nil
            -- player.player_classified._worldpickercurrentindex = nil
            player.player_classified._worldpickercurrentdest = nil
        end
    end
)
AddModRPCHandler(
    --更改当前目的地
    "multiworldpicker",
    "worldpickerdestRPC",
    --prev为true则表示前一个，否则是后一个
    function(player, prev)
        -- if player == nil then
        --     return
        -- end
        -- print("[MWP] RPC worldpicker DEST handling")
        if
            player.player_classified.worldpickervisible:value() and
                player.player_classified._worldpickercurrentindex ~= nil
         then
            local i = player.player_classified._worldpickercurrentindex + (prev == true and -1 or 1)
            local len = #_G.TheWorld.ShardList
            i = (len + i - 1) % len + 1
            local dest = _G.TheWorld.ShardList[i]
            local count = _G.TheWorld.ShardPlayerCounts[dest]
            -- print("[MWP] RPC worldpicker DEST:", dest, count)
            if dest and count then
                player.player_classified._worldpickercurrentindex = i
                player.player_classified._worldpickercurrentdest = dest
                local max =
                    _G.tonumber(_config.population_limit[dest]) or _G.tonumber(_config.population_limit._other) or 0
                player.player_classified.worldpickeronline:set(max > 0 and count .. "/" .. max or "" .. count)
                local name = _config.world_name[dest] or STRINGS.MWP.WORLD .. dest
                player.player_classified.worldpickerdest:set(name)
            end
        end
    end
)
AddModRPCHandler(
    --migrate to
    "multiworldpicker",
    "worldpickermigrateRPC",
    function(player)
        -- if player == nil then
        --     return
        -- end
        -- print("[MWP] RPC worldpicker MIGRATE handling")
        player.player_classified.worldpickervisible:set_local(false)

        local portalId = player.player_classified._worldpickerportalid
        local dest = player.player_classified._worldpickercurrentdest
        local count = _G.TheWorld.ShardPlayerCounts[dest]
        if portalId and _G.tonumber(dest) and count then
            local max = _G.tonumber(_config.population_limit[dest]) or _G.tonumber(_config.population_limit._other) or 0
            if max > 0 and count >= max then
                -- print("[MWP] RPC MIGRATE dest is full", portalId, dest, count)
                if player.components and player.components.talker then
                    player.components.talker:Say(STRINGS.MWP.WORLD_FULL)
                end
                return
            end

            -- print("[MWP] RPC MIGRATE prepare for migration:", _G.type(portalId), portalId, dest, count)
            local paras = {player = player, portalid = portalId, worldid = _G.tonumber(dest)}

            local delay = 0.1
            --用talker提示玩家去往的目的地
            if say_dest then
                delay = 1
                if player.components and player.components.talker then
                    local name = _config.world_name[dest] or STRINGS.MWP.WORLD .. dest
                    player.components.talker:Say(STRINGS.MWP.GOING_TO .. name)
                end
            end

            _G.TheWorld:DoTaskInTime(
                delay,
                function(world)
                    world:PushEvent("ms_playerdespawnandmigrate", paras)
                end
            )
            return
        end
        if player.components and player.components.talker then
            player.components.talker:Say(STRINGS.MWP.WORLD_INVALID)
        end

        -- player.player_classified._worldpickerportalid = nil
        -- player.player_classified._worldpickercurrentindex = nil
        -- player.player_classified._worldpickercurrentdest = nil
    end
)

--添加屏幕控件到HUD
local function addWorldPicker(inst)
    -- print("[MWP] add WorldPicker to HUD", inst)
    function inst:OpenWorldPickerScreen(dest, count)
        -- print("[MWP] Showing world picker, Dest: " .. dest)

        if self.pickworldscreen ~= nil then
            return self.pickworldscreen
        end
        --显示widget应当传入显示参数(目的地，人数统计)
        self.pickworldscreen = PickWorldScreen(self.owner, dest, count)
        self:OpenScreenUnderPause(self.pickworldscreen)
        _G.TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/craft_open")
        return self.pickworldscreen
    end
    function inst:CloseWorldPickerScreen()
        -- print("[MWP] Closing world picker")
        if self.pickworldscreen then
            self.pickworldscreen:Close()
            self.pickworldscreen = nil
        end
        --发送RPC，通知服务端 控件已关闭
        self.owner.player_classified.worldpickervisible:set_local(false)
        SendModRPCToServer(MOD_RPC["multiworldpicker"]["worldpickervisibleRPC"])
    end
end
AddClassPostConstruct("screens/playerhud", addWorldPicker)

-- _G.ACTIONS.MIGRATE._oldfn = _G.ACTIONS.MIGRATE.fn
-- _G.ACTIONS.MIGRATE.fn = function(act)
--     --fail reasons: "NODESTINATION"
--     return _G.MIGRATE._oldfn
-- end

local function migrator(inst)
    --ValidateAndPushEvents
    -- inst._oldValidateAndPushEvents = inst.ValidateAndPushEvents
    -- function inst:ValidateAndPushEvents()
    --     return inst:_oldValidateAndPushEvents()
    -- end

    --WorldMigrator:IsDestinationForPortal(otherWorld, otherPortal)
    function inst:IsDestinationForPortal(_, otherPortal)
        --跳過對 World id 的驗證
        return self.receivedPortal == otherPortal
    end

    --Activate
    inst._oldActivate = inst.Activate
    function inst:Activate(doer)
        if doer == nil then
            return false
        end

        --若設置了忽略落水洞，則直接返回
        -- print("[MWP] Hook worldmigrator:Activate------------\n", self, self.inst, self.inst.prefab)
        if ignore_sinkholes and self.inst.prefab == "cave_entrance_open" then
            return self:_oldActivate(doer)
        end

        -- 只有一个Shard直接migrate
        if
            _G.TheWorld.ShardList == nil or #_G.TheWorld.ShardList == 0 or
                (#_G.TheWorld.ShardList + #_config.invisible_worlds < 2)
         then
            return self:_oldActivate(doer)
        end
        if #_G.TheWorld.ShardList == 1 then
            local dest = _G.TheWorld.ShardList[1]
            local worldId = _G.tonumber(dest)
            local portalId = self.id or 0
            if worldId ~= nil and not _config.invisible_worlds[dest] then
                _G.TheWorld:PushEvent(
                    "ms_playerdespawnandmigrate",
                    {player = doer, portalid = portalId, worldid = worldId}
                )
                return
            end

            doer.components.talker:Say(STRINGS.MWP.WHERE_TO_GO)
            return
        end

        --服务端doer.HUD==nil，透过player_classified显示控件
        --限制同一玩家连续开启控件间隔时间2秒
        if doer.mwp_last_show_wp == nil or (_G.os.time() - doer.mwp_last_show_wp) > 2 then
            doer.mwp_last_show_wp = _G.os.time()
            doer.player_classified:ShowWorldPickerPopup(true, self.id)
        elseif doer.components and doer.components.talker then
            doer.components.talker:Say(STRINGS.MWP.WHERE_TO_GO)
        end
        return true
    end
end
AddComponentPostInit("worldmigrator", migrator)

-- player_classified

local function OnWorldPickerVisibleDirty(inst)
    if inst._parent ~= nil and inst._parent.HUD ~= nil then
        if not inst.worldpickervisible:value() then
            inst._parent.HUD:CloseWorldPickerScreen()
        else
            inst._parent.HUD:OpenWorldPickerScreen(inst.worldpickerdest:value(), inst.worldpickeronline:value())
        end
    end
end

local function OnWorldPickerDestDirty(inst)
    --TODO: 当目的地改变时，更改UI显示
    if inst._parent ~= nil and inst._parent.HUD ~= nil then
        if not inst.worldpickervisible:value() then
            inst._parent.HUD:CloseWorldPickerScreen()
        elseif inst._parent.HUD.pickworldscreen ~= nil then
            inst._parent.HUD.pickworldscreen:SetDest(inst.worldpickerdest:value())
            inst._parent.HUD.pickworldscreen:SetCount(inst.worldpickeronline:value())
        end
    end
end

-- local function OnWorldPickerCountDirty(inst)
--     --当统计人数改变时刷新UI显示（实现起来较为麻烦，暂时搁置）
--     if inst._parent ~= nil and inst._parent.HUD ~= nil then
--         if not inst.worldpickervisible:value() then
--             return
--         elseif inst._parent.HUD.pickworldscreen ~= nil then
--             -- inst._parent.HUD.pickworldscreen:SetDest(inst.worldpickerdest:value())
--             inst._parent.HUD.pickworldscreen:SetCount(inst.worldpickeronline:value())
--         end
--     end
-- end

local function addtoplayerclassified(inst)
    -- print("[MWP] Hello Player_Classified:")
    -- print(inst)
    --声明网络变量
    --    控件可见性       isvisible: bool
    --    当前目的地       worlddest: string
    --    人数  在线/最大  online:    string  用字符串以减少网络变量个数
    inst.worldpickervisible = _G.net_bool(inst.GUID, "worldpicker.worldpickervisible", "worldpickervisibledirty")
    inst.worldpickerdest = _G.net_string(inst.GUID, "worldpicker.worldpickerdest", "worldpickerdestdirty")
    inst.worldpickeronline = _G.net_string(inst.GUID, "worldpicker.worldpickeronline", "worldpickercountdirty")
    -- inst.worldpickeronline:set_local("")

    --注册监听器
    --Delay net listeners until after initial values are deserialized
    --inst:DoTaskInTime(0, RegisterNetListeners)
    inst:DoTaskInTime(
        0,
        function(obj)
            if _G.TheWorld.ismastersim then
                -- print("[MWP] Server Registering Net Listeners")
            else
                -- print("[MWP] Client Registering Net Listeners")
                -- obj:ListenForEvent("worldpickercountdirty", OnWorldPickerCountDirty)
                obj:ListenForEvent("worldpickervisibledirty", OnWorldPickerVisibleDirty)
                obj:ListenForEvent("worldpickerdestdirty", OnWorldPickerDestDirty)
            end
        end
    )
    --设置客户端与服务器接口
    if not _G.TheWorld.ismastersim then
        --客户端接口
        --  ...
        return
    end
    --服务端接口
    function inst:ShowWorldPickerPopup(show, portalid)
        -- print("[MWP]Showing World Picker Popup", show, portalid)
        if show then
            --初始化必要的参数
            self._worldpickerportalid = portalid or 0
            self._worldpickercurrentindex = self._worldpickercurrentindex or 1
            self._worldpickercurrentdest =
                _G.TheWorld.ShardList[self._worldpickercurrentindex] or self._worldpickercurrentindex .. "???"

            --设置Widget初始显示参数
            local destname =
                _config.world_name[self._worldpickercurrentdest] or STRINGS.MWP.WORLD .. self._worldpickercurrentdest
            local count = _G.TheWorld.ShardPlayerCounts[self._worldpickercurrentdest] or "NIL"
            -- print("[MWP] ShowWorldPickerPopup:", self._worldpickerportalid, destname, count)
            local max =
                _G.tonumber(_config.population_limit[self._worldpickercurrentdest]) or
                _G.tonumber(_config.population_limit._other) or
                0
            self.worldpickeronline:set(max > 0 and count .. "/" .. max or "" .. count)
            self.worldpickerdest:set(destname)
        end
        self.worldpickervisible:set(show)
        OnWorldPickerVisibleDirty(self)
        OnWorldPickerDestDirty(self)
    end
end
AddPrefabPostInit("player_classified", addtoplayerclassified)

--覆盖使用传送口的动作以避免卡住
AddStategraphActionHandler("wilson", _G.ActionHandler(_G.ACTIONS.MIGRATE, "doshortaction"))
AddStategraphActionHandler("wilson_client", _G.ActionHandler(_G.ACTIONS.MIGRATE, "doshortaction"))
AddStategraphActionHandler("wilsonghost", _G.ActionHandler(_G.ACTIONS.MIGRATE, "haunt_pre"))
AddStategraphActionHandler("wilsonghost_client", _G.ActionHandler(_G.ACTIONS.MIGRATE, "haunt_pre"))

--通过系统消息实现同步shards人数信息
local _oldNetworking_SystemMessage = _G.Networking_SystemMessage
_G.Networking_SystemMessage = function(message)
    if string.sub(message, 1, 3) == "`s~" and _G.TheWorld ~= nil then
        if _G.TheWorld.ismastersim and _G.TheWorld.ShardPlayerCounts ~= nil then
            local msg = string.sub(message, 4)
            if msg then
                local fields = msg:split() --util.lua 86, returns a table
                if #fields == 2 then
                    local id = fields[1]
                    if _G.tonumber(id) == nil then
                        return
                    end
                    local count = fields[2]
                    -- print("[MWP] Updating ShardPlayerCounts:", id, count)
                    _G.TheWorld.ShardPlayerCounts[id] = _G.tonumber(count) or 0
                end
            end
        end
    else
        _oldNetworking_SystemMessage(message)
    end
end

--将大门作为洞口
if migration_postern then
    --禁止幽灵玩家通过大门 migrate 以防冲突
    AddComponentAction(
        "SCENE",
        "worldmigrator",
        function(inst, doer, actions, right)
            -- print("----------------------------------------------------------------")
            -- print("[MWP] AddComponentAction", inst, doer, actions, right, #actions)
            local removeAction = function()
                local i = 1
                while i <= #actions do
                    if actions[i] == _G.ACTIONS.MIGRATE then
                        -- print("[MWP] removing migrate action", actions, actions[i])
                        table.remove(actions, i)
                        break
                    else
                        i = i + 1
                    end
                end
            end
            local isDead = doer:HasTag("playerghost")
            local isConstr = inst.prefab == "multiplayer_portal_moonrock_constr"
            local isRsrctr = inst:HasTag("resurrector")
            if (isRsrctr and isDead) or (isConstr and not isDead) then
                if right and not isDead then
                    table.insert(actions, _G.ACTIONS.MIGRATE)
                else
                    removeAction()
                end
            end
            -- print("========================================================")
        end
    )
    --给大门添加 worldmigrator
    if _G.TheNet:GetIsServer() then
        local portals = {
            "multiplayer_portal",
            "multiplayer_portal_moonrock_constr",
            "multiplayer_portal_moonrock"
        }
        local addMigrator = function(inst)
            inst:AddComponent("worldmigrator")
            --洞口ID直接设为 0
            inst.components.worldmigrator:SetID(0)
        end
        for _, v in ipairs(portals) do
            AddPrefabPostInit(v, addMigrator)
        end
    end
end

--仅服务端
if _G.TheNet:GetIsServer() then
    --创建角色后自动分配玩家到人数少的服务器
    if auto_balancing then
        --是否有空余位置
        local function has_vacancy(world_id)
            local max =
                _G.tonumber(_config.population_limit[world_id]) or _G.tonumber(_config.population_limit._other) or 0
            if max < 1 then
                return true
            end
            local v =
                max - (_G.TheWorld.ShardPlayerCounts and _G.tonumber(_G.TheWorld.ShardPlayerCounts[world_id]) or 0)
            return v > 0
        end
        --得出分流去往的目标世界 ID:number or nil
        local function getTargetWorld()
            --主世界只有当前玩家一人则返回nil，不分流
            if #_G.AllPlayers > 1 and _G.TheWorld.ShardPlayerCounts then
                local id = _G.TheShard:GetShardId()
                for i, v in ipairs(_G.TheWorld.ShardList) do
                    if _config.extra_worlds[v] ~= true then
                        if _G.TheWorld.ShardPlayerCounts[v] == 0 then
                            id = v
                            break
                        elseif _G.TheWorld.ShardPlayerCounts[v] < _G.TheWorld.ShardPlayerCounts[id] and has_vacancy(v) then
                            id = v
                        end
                    end
                end
                return _G.tonumber(id ~= _G.TheShard:GetShardId() and id)
            end
            return nil
        end

        local _oldSpawnNewPlayerOnServerFromSim = _G.SpawnNewPlayerOnServerFromSim
        _G.SpawnNewPlayerOnServerFromSim = function(
            player_guid,
            skin_base,
            clothing_body,
            clothing_hand,
            clothing_legs,
            clothing_feet)
            -- print("[MWP] player new spawn", player_guid)
            -- if _G.TheWorld.ismastersim then
            local player = _G.Ents[player_guid]
            if player ~= nil then
                local worldId = getTargetWorld()
                if worldId ~= nil then
                    -- print("[MWP] Assigning player to", worldId)
                    player:DoTaskInTime(
                        0,
                        function(player)
                            _G.TheWorld:PushEvent(
                                "ms_playerdespawnandmigrate",
                                {player = player, portalid = 0, worldid = worldId}
                            )
                        end
                    )
                end
            end
            -- end
            _oldSpawnNewPlayerOnServerFromSim(
                player_guid,
                skin_base,
                clothing_body,
                clothing_hand,
                clothing_legs,
                clothing_feet
            )
        end
    end

    --若某个世界断开连接，当重新注册落水洞，防止洞口被堵住
    --将所连接的shards之id:string存为数组 TheWorld.ShardList
    --初始化并维护 TheWorld.ShardPlayerCounts 表，存储全部shards人数
    local _oldShard_UpdateWorldState = _G.Shard_UpdateWorldState
    _G.Shard_UpdateWorldState = function(world_id, state, tags, world_data)
        _oldShard_UpdateWorldState(world_id, state, tags, world_data)

        --防止世界重置时TheWorld为nil崩溃
        if _G.TheWorld == nil then
            return
        end

        -- REMOTESHARDSTATE = {
        --     READY   = 1 ,
        --     OFFLINE = 0
        -- }
        local ready = state == _G.REMOTESHARDSTATE.READY

        if not ready or _G.TheWorld.ShardList == nil then
            _G.TheWorld.ShardList = {}
            for k, _ in pairs(_G.Shard_GetConnectedShards()) do
                if not _config.invisible_worlds[k] then
                    table.insert(_G.TheWorld.ShardList, k)
                else
                    print("[MWP] this world is set to invisible:", k)
                end
            end
        else
            if table.contains(_G.TheWorld.ShardList, world_id) then
                print("[MWP] the world was already added to TheWorld.ShardList:", world_id)
            else
                if not _config.invisible_worlds[world_id] then
                    table.insert(_G.TheWorld.ShardList, world_id)
                else
                    print("[MWP] this world is set to invisible:", world_id)
                end
            end
        end

        if _G.TheWorld.ShardPlayerCounts == nil then
            _G.TheWorld.ShardPlayerCounts = {}
            _G.TheWorld.ShardPlayerCounts[_G.TheShard:GetShardId()] = #_G.AllPlayers
            for _, v in ipairs(_G.TheWorld.ShardList) do
                _G.TheWorld.ShardPlayerCounts[v] = 0
            end
        else
            if ready then
                _G.TheWorld.ShardPlayerCounts[world_id] = 0
            else
                _G.TheWorld.ShardPlayerCounts[world_id] = nil
            end
        end
        --当有世界断开时刷新洞口连接
        --shardlist为空则不刷新
        if not ready and #_G.TheWorld.ShardList > 0 then
            for k, v in pairs(_G.ShardPortals) do
                if (v.components.worldmigrator.linkedWorld == nil or v.components.worldmigrator.auto == true) then
                    -- print("[MWP]---------------- Reregister Portals 刷新洞口连接 ----------------")
                    _G.c_reregisterportals()
                    break
                end
            end
        end
    end

    --防止洞口生成蝙蝠
    if no_bat then
        AddPrefabPostInit(
            "cave_entrance_open",
            function(inst)
                if inst.components.childspawner ~= nil then
                    inst.components.childspawner:SetMaxChildren(0)
                end
            end
        )
    end

    AddSimPostInit(
        function()
            ---广播人数信息 START---
            local shardId = _G.TheShard:GetShardId()
            --msg -> "`s~1:3" -> 世界1人数3
            local function SendCountMsg()
                -- print("[MWP] Sending Count: ", #_G.AllPlayers, shardId)
                local msg = "`s~" .. shardId .. ":" .. #_G.AllPlayers
                _G.TheNet:SystemMessage(msg)
            end

            --player spawn
            _G.TheWorld:ListenForEvent("ms_playerspawn", SendCountMsg)
            --player left
            _G.TheWorld:ListenForEvent("ms_playerleft", SendCountMsg)
            ---广播人数信息 END---
            --
            ---当进入世界时，告诉玩家当前所在的世界名称
            if world_prompt then
                local function prompt(src, player)
                    if player ~= nil then
                        player:DoTaskInTime(
                            1,
                            function(doer)
                                if doer and doer.components and doer.components.talker then
                                    local worldname =
                                        _config.world_name[_G.TheShard:GetShardId()] or
                                        STRINGS.MWP.WORLD .. _G.TheShard:GetShardId()
                                    doer.components.talker:Say(STRINGS.MWP.HERE_IS .. worldname)
                                end
                            end
                        )
                    end
                end
                --player spawn
                _G.TheWorld:ListenForEvent("ms_playerspawn", prompt)
            end
            ---END---
        end
    )

    --打印连接的shards
    _G.mwp_shards = function()
        local name
        for i, v in ipairs(_G.TheWorld.ShardList) do
            name = _config.world_name[v] or STRINGS.MWP.WORLD .. v
            print(string.format("%d)\t%s\t%s", i, v, name))
        end
        if #_config.invisible_worlds > 0 then
            print("There are invisible worlds: ")
            for i, v in ipairs(_config.invisible_worlds) do
                name = _config.world_name[v] or STRINGS.MWP.WORLD .. v
                print(string.format("%d)\t%s\t%s", i, v, name))
            end
        end
    end

    --打印 ShardPlayerCounts
    _G.mwp_counts = function()
        local max, name
        print("ShardPlayerCounts:")
        for k, v in pairs(_G.TheWorld.ShardPlayerCounts) do
            max = _G.tonumber(_config.population_limit[k]) or _G.tonumber(_config.population_limit._other) or 0
            name = _config.world_name[k] or STRINGS.MWP.WORLD .. k
            print(string.format("%d/%d\t%s\t[%s]", v, max, name, k))
        end
    end

    --打印当前世界信息
    --格式
    --[2] {@} (3/12) 挑战世界
    _G.mwp_this = function()
        local id = _G.TheShard:GetShardId()
        local name = _config.world_name[id] or STRINGS.MWP.WORLD .. id
        local max = _G.tonumber(_config.population_limit[id]) or _G.tonumber(_config.population_limit._other) or 0
        local count = _G.TheWorld.ShardPlayerCounts[id] or 0
        print(string.format("[%s] {@} (%d/%d) %s", id, count, max, name))
    end

    --列出所有Shards信息
    -- {@} -> current
    -- {*} -> invisible
    -- {^} -> extra
    -- { } -> other
    _G.mwp_list = function()
        local max, name, count, char
        print("All Worlds:")
        for k, _ in pairs(_G.Shard_GetConnectedShards()) do
            max = _G.tonumber(_config.population_limit[k]) or _G.tonumber(_config.population_limit._other) or 0
            name = _config.world_name[k] or STRINGS.MWP.WORLD .. k
            count = _G.TheWorld.ShardPlayerCounts[k] or 0
            if _config.invisible_worlds[k] then
                char = "*"
            elseif _config.extra_worlds[k] then
                char = "^"
            else
                char = " "
            end
            print(string.format("[%s] {%s} (%d/%d) %s", k, char, count, max, name))
        end
        _G.mwp_this()
    end

--事件监听测试
--监听spawn/left？
-- AddSimPostInit(
--     function()
--         local shardId = _G.TheShard:GetShardId()
--         local events = {
--             "ms_playerdespawn",
--             "ms_playerdespawnanddelete",
--             "ms_playerdespawnandmigrate",
--             "ms_playerspawn",
--             "ms_playerjoined",
--             "ms_playerleft",
--             "ms_playerdisconnected",
--             "ms_playercounts",
--             "entercharacterselect"
--         }
--         local function printArgs(ev, ...)
--             -- print("[MWP] Event:", ev, shardId, ...)
--         end

--         for k, v in pairs(events) do
--             _G.TheWorld:ListenForEvent(
--                 v,
--                 function(src, para, ev)
--                     printArgs(v, para)
--                 end
--             )
--         end
--     end
-- )
end
