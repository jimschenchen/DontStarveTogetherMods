local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local TEMPLATES = require "widgets/redux/templates"

local function onclose(inst)
    if not inst.isopen then
        return
    end
    -- TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/craft_close")
    inst.owner.HUD:CloseWorldPickerScreen()
end

local function onaccept(inst)
    --TODO: Send RPC to Server to Migrate
    -- print("[MWP] pickworld screen onaccept")
    SendModRPCToServer(MOD_RPC["multiworldpicker"]["worldpickermigrateRPC"])
    --close pickworldscreen
    onclose(inst)
end

local function onnextdest(inst)
    --TODO: Send RPC to get next destination
    -- print("[MWP] pickworld screen onnextdest")
    SendModRPCToServer(MOD_RPC["multiworldpicker"]["worldpickerdestRPC"])
end

local function onprevdest(inst)
    --TODO: Send RPC to get prev destination
    -- print("[MWP] pickworld screen onprevdest")
    SendModRPCToServer(MOD_RPC["multiworldpicker"]["worldpickerdestRPC"], true)
end

local function activateImgBtn(btn, down)
    if down then
        if not btn.down then
            if btn.has_image_down then
                btn.image:SetTexture(btn.atlas, btn.image_down)

                if btn.size_x and btn.size_y then
                    btn.image:ScaleToSize(btn.size_x, btn.size_y)
                end
            end
            TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
            btn.o_pos = btn:GetLocalPosition()
            if btn.move_on_click then
                btn:SetPosition(btn.o_pos + btn.clickoffset)
            end
            btn.down = true
            if btn.whiledown then
                btn:StartUpdating()
            end
            if btn.ondown then
                btn.ondown()
            end
        end
    else
        if btn.down then
            if btn.has_image_down then
                btn.image:SetTexture(btn.atlas, btn.image_focus)

                if btn.size_x and btn.size_y then
                    btn.image:ScaleToSize(btn.size_x, btn.size_y)
                end
            end
            btn.down = false
            btn:ResetPreClickPosition()
            if btn.onclick then
                btn.onclick()
            end
            btn:OnLoseFocus()
            btn:StopUpdating()
        end
    end
end

local PickWorldScreen =
    Class(
    Screen,
    function(self, owner, str_dest, str_count)
        Screen._ctor(self, "WorldPicker")
        self.owner = owner
        self.isopen = false
        self.controller_mode = TheInput:ControllerAttached()
        self._scrnw, self._scrnh = TheSim:GetScreenSize()
        self:SetScaleMode(SCALEMODE_PROPORTIONAL)
        self:SetMaxPropUpscale(MAX_HUD_SCALE)
        self:SetPosition(0, 0, 0)
        self:SetVAnchor(ANCHOR_MIDDLE)
        self:SetHAnchor(ANCHOR_MIDDLE)
        self.scalingroot = self:AddChild(Widget("worldpickerscalingroot"))
        self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
        self.inst:ListenForEvent(
            "continuefrompause",
            function()
                if self.isopen then
                    self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
                end
            end,
            TheWorld
        )
        self.inst:ListenForEvent(
            "refreshhudsize",
            function(hud, scale)
                if self.isopen then
                    self.scalingroot:SetScale(scale)
                end
            end,
            owner.HUD.inst
        )

        --[=>=[屏幕填充
        self.black = self.scalingroot:AddChild(ImageButton("images/global.xml", "square.tex"))
        self.black.image:SetVRegPoint(ANCHOR_MIDDLE)
        self.black.image:SetHRegPoint(ANCHOR_MIDDLE)
        self.black.image:SetVAnchor(ANCHOR_MIDDLE)
        self.black.image:SetHAnchor(ANCHOR_MIDDLE)
        self.black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
        self.black.image:SetTint(0, 0, 0, 0)
        self.black:SetOnClick(
            function()
                onclose(self)
            end
        )
        self.black:SetHelpTextMessage("")
        -- self.black.OnMouseButton = function()
        --     print("[MWP] self.black.OnMouseButton return true")
        --     -- onclose(self)
        --     return true
        -- end
        --]=>=]
        self.root = self.scalingroot:AddChild(Widget("worldpickerroot"))
        self.root:SetScale(1, 1, 1)
        self.root:SetPosition(0, 180, 0)

        --主面板背景
        self.bg = self.root:AddChild(Image("images/wpicker.xml", "wpicker_bg_board.tex"))
        self.bg:SetScale(1, 1, 1)

        --面板标题
        self.title = self.root:AddChild(Text(HEADERFONT, 28, STRINGS.MWP.SELECT_WORLD))
        self.title:SetPosition(0, 70, 0)

        --当前选定目标世界
        self.dest = self.root:AddChild(Text(NEWFONT_OUTLINE, 35, ""))
        self.dest:SetPosition(0, 24, 0)

        --「前一个世界」按钮
        self.btn_prev =
            self.root:AddChild(
            ImageButton(
                "images/global_redux.xml",
                "arrow2_left.tex",
                "arrow2_left_over.tex",
                nil,
                "arrow2_left_down.tex",
                nil,
                {1, 1},
                {0, 55}
            )
        )
        self.btn_prev:SetTextSize(28)
        if self.controller_mode then
            self.btn_prev:SetText(TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_SCROLLBACK), false)
        end
        self.btn_prev:SetScale(0.65, 0.65, 0.65)
        self.btn_prev:SetPosition(-155, -15, 0)
        self.btn_prev:SetOnClick(
            function()
                onprevdest(self)
            end
        )

        --「后一个世界」按钮
        self.btn_next =
            self.root:AddChild(
            ImageButton(
                "images/global_redux.xml",
                "arrow2_right.tex",
                "arrow2_right_over.tex",
                nil,
                "arrow2_right_down.tex",
                nil,
                {1, 1},
                {0, 55}
            )
        )
        self.btn_next:SetTextSize(28)
        if self.controller_mode then
            self.btn_next:SetText(TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_SCROLLFWD), false)
        end
        self.btn_next:SetScale(0.65, 0.65, 0.65)
        self.btn_next:SetPosition(155, -15, 0)
        self.btn_next:SetOnClick(
            function()
                onnextdest(self)
            end
        )

        --在线人数显示
        self.count = self.root:AddChild(Text(NEWFONT_OUTLINE, 23, ""))
        self.count:SetPosition(0, -20, 0)

        --确认按钮
        self.btn_go =
            self.root:AddChild(
            ImageButton(
                "images/wpicker.xml",
                "wpicker-button-area.tex",
                "wpicker-button-area-hover.tex",
                nil,
                "wpicker-button-area-pressed.tex",
                nil,
                {1, 1},
                {0, -3}
            )
        )
        self.btn_go:SetTextColour(UICOLOURS.GOLD)
        self.btn_go:SetTextFocusColour(PORTAL_TEXT_COLOUR)
        self.btn_go:SetFont(NEWFONT_OUTLINE)
        self.btn_go:SetDisabledFont(NEWFONT_OUTLINE)
        self.btn_go:SetTextDisabledColour(UICOLOURS.GOLD)
        self.btn_go:SetTextSize(28)
        --TODO：当存在控制器，显示控制器按键图标
        local text_btn_go = STRINGS.MWP.LEAVE_FOR
        if self.controller_mode then
            text_btn_go =
                TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_ACCEPT) .. "  " .. text_btn_go
            self.btn_go:SetTextSize(20)
        end
        self.btn_go:SetText(text_btn_go, true)
        self.btn_go:SetScale(1.2, 1.2, 1.2)
        self.btn_go:SetPosition(0, -78, 0)
        -- self.btn_go:SetControl(CONTROL_ACCEPT)
        self.btn_go:SetOnClick(
            function()
                onaccept(self)
            end
        )

        self:SetDest(str_dest)
        self:SetCount(str_count)

        self.isopen = true
        self:Show()
    end
)

-- function PickWorldScreen:OnBecomeActive()
--     self._base.OnBecomeActive(self)
--     -- self.spinner:SetFocus()
-- end

function PickWorldScreen:SetDest(dest)
    --更改当前显示的目标世界名称
    if dest == nil then
        return
    end
    -- print("[MWP] Set Dest:", dest)
    self.dest:SetString(dest)
end

function PickWorldScreen:SetCount(str_count)
    --设置显示人数统计的字符串
    if str_count == nil or str_count == "" then
        -- print("[MWP] Set Online: No Information")
        self.count:SetString("")
    else
        -- print("[MWP] Set Online:", str_count)
        self.count:SetString(STRINGS.MWP.PLAYER_COUNT .. str_count)
    end
end

function PickWorldScreen:Close()
    if self.isopen then
        -- self.black:Kill()
        self.isopen = false
        TheFrontEnd:PopScreen(self)
    end
end

function PickWorldScreen:OnRawKey(key, down)
    -- print("[MWP] PickWorldScreen:OnRawKey", key, down)

    if key == KEY_RIGHT or key == KEY_DOWN then
        activateImgBtn(self.btn_next, down)
        return true
    end
    if key == KEY_SPACE then
        -- print("[MWP] ON Accept Keys", key, false)
        activateImgBtn(self.btn_go, down)
        return true
    -- return self:OnControl(CONTROL_ACCEPT, down)
    end
    if key == KEY_LEFT or key == KEY_UP then
        activateImgBtn(self.btn_prev, down)
        return true
    end
end

function PickWorldScreen:OnControl(control, down)
    if PickWorldScreen._base.OnControl(self, control, down) then
        return true
    end

    -- print("[MWP] PickWorldScreen:OnControl", control, down)

    if self.controller_mode then
        if control == CONTROL_SCROLLFWD then
            activateImgBtn(self.btn_next, down)
            return true
        end
        if control == CONTROL_ACCEPT then
            -- print("[MWP] ON Accept Control:", control, false)
            activateImgBtn(self.btn_go, down)
            return true
        end
        if control == CONTROL_SCROLLBACK then
            activateImgBtn(self.btn_prev, down)
            return true
        end
    end

    if not down and (control == CONTROL_CANCEL or control == CONTROL_OPEN_DEBUG_CONSOLE) then
        onclose(self)
        return true
    end
    --see constants.lua
    --if control == 下一、前一，then onnextdest()、onprevdest() end
end
return PickWorldScreen
