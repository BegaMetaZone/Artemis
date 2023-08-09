Arta = {}
Arta.VehInfo = {} 
Arta.Config = {}
Arta.Timetrials = {}
Arta.Timetrials.Races = {}
Arta.Player = {}
Arta.Timetrials.RaceState = {
    cP = 1,
    index = 0 ,
    scores = nil,
    startTime = 0,
    blip = nil,
    checkpoint = nil
}

local races = exports["timetrials"]:GetRaces()
Arta.Timetrials.Races = races
--------------------

---------------------
Arta.Player.Name = GetPlayerName(PlayerId())



function Arta.MainMenu()
    local txd = CreateRuntimeTxd("scaleformui")
    local duiPanel = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160)
    CreateRuntimeTextureFromDuiHandle(txd, "sidepanel", GetDuiHandle(duiPanel))
	local duiBanner = CreateDui("https://i.imgur.com/3yrFYbF.gif", 288, 160)
	CreateRuntimeTextureFromDuiHandle(txd, "menuBanner", GetDuiHandle(duiBanner))
	-- 
    
	Arta.Timetrials.RaceState = exports["timetrials"]:GetRaceState()

	--

    local RaceMenu = UIMenu.New("RaceMenu", "Powered by ScaleformUI", 50, 50, true, "scaleformui", "menuBanner", true)
    RaceMenu:MaxItemsOnScreen(7)
    RaceMenu:MouseControlsEnabled(true)
    RaceMenu:MouseEdgeEnabled(false)
    RaceMenu:ControlDisablingEnabled(true)
    RaceMenu:BuildingAnimation(MenuBuildingAnimation.LEFT_RIGHT)
    RaceMenu:AnimationType(MenuAnimationType.CUBIC_INOUT)
	RaceMenu:ScrollingType(MenuScrollingType.CLASSIC)
	RaceMenu:CounterColor(Colours.HUD_COLOUR_YELLOW)

    local currentTransition = "TRANSITION_OUT"
    ------------------------------- Personal Vehicle --------------------------------------
    local showVehicleList = false

	local vehicleMods = nil
    local VehInfo = TriggerEvent("RMGetVehicleInfo")
    ------- Personal Vehicle Main Menu Items 
    local MyCarMainItem = UIMenuItem.New("Personal Vehicle" , "Personal Vehicle Menu")
    RaceMenu:AddItem(MyCarMainItem)
    
    local MyCarMenu = UIMenu.New("Personal Vehicle", "Personal Vehicle", 50, 50, true, nil, nil, true)
    --------- Pimp My Ride -- RaceMenu Customs 
        local MyCarCustomsItem = UIMenuItem.New("RaceMenu Customs" , "Customization Menu")
        MyCarMenu:AddItem(MyCarCustomsItem)
        --- Customs Menu 
        -------------------------
        MyCarCustomsItem.Activated = function(menu, item) -- adds funtion to item and the function is scaleforms switchto 
            Arta.LSCustoms()
        end
    ------- Personal Vehicle Menu Register 

    MyCarItem.Activated = function(menu, item)
        menu:SwitchTo(MyCarMenu, 1, true)
    end
    ---------------------------------------------------------------------------------------
    ------------------------------- LeaderBoard -------------------------------------------

    local TimeTrialItem = UIMenuItem.New("Time Trials", "leaderboard")
    RaceMenu:AddItem(TimeTrialItem)
    local TimeTrialMenu = UIMenu.New("TimeTrials", "Time Trial Races", 50, 50, true, nil, nil, true)
	-- populate menu with races 
	-- we're gonna use this for template UIMenuItem.New(text, description, color, highlightColor, textColor, highlightedTextColor)
	-- and smtn like this is also used to register it , TimeTrialMenu:AddItem(uiItemTransitionList)
    ------------------------------------------------------------------------------------
    ------------------------------ Score Handlers --------------------------------------
    ------------------------------------------------------------------------------------

	for index, race in pairs(Arta.Timetrials.Races) do
		--print(race.title) works
		if race.isEnabled then
				-- If we've received updated scores, display them 
			if Arta.Timetrials.RaceState.scores ~= nil then
					-- Get scores for this race and sort them
				raceScores = Arta.Timetrials.RaceState.scores[race.title]
                --print(raceScores) --debug
				if raceScores ~= nil then
						local sortedScores = {}			
						---
						for k, v in pairs(raceScores) do
							table.insert(sortedScores, { key = k, value = v })
						end
						table.sort(sortedScores, function(a,b) return a.value.time < b.value.time end)

						-- Create new list with scores to populate
						local count = 0
						drawScores = {}
						for k, v in pairs(sortedScores) do
							if count < 1 then
								count = count + 1
								table.insert(drawScores, v.value)
							end
						end

						
						for k, score in pairs(drawScores) do
							-- top 1 score
							--print(score.time) --debug	car player time		
                            
                            if score.time then
                                local DestX = race.start.x
                                local DestY = race.start.y
                                local TTTKing = score.player
                                print("wooooo ,pst pst " .. score.player .. score.time/1000.0) -- debug
                                local TrackScoreItem = UIMenuItem.New(race.title,"~HUD_COLOUR_GOLD~Leaderboard King : " .. score.player .. "~n~Vehicle                  : " .. score.car .. "~n~Time                      : " .. score.time/1000.0 .. " s")
                                TimeTrialMenu:AddItem(TrackScoreItem)
                                --TrackScoreItem:LeftBadge(BadgeStyle.MEDAL_GOLD) --tmp
                                TrackScoreItem:RightLabel(score.player)
                                --TrackScoreItem:LabelFont(ScaleformFonts.GTAV_LEADERBOARD)
                                TrackScoreItem:RightLabelFont(ScaleformFonts.PRICEDOWN_GTAV_INT) --tmp 
                                TrackScoreItem.Activated = function(menu, item)
                                --    RMSetWayPoint(DestX, DestY)
                                    --CreateLobbyMenu()
                                  end                      
                                if Arta.Player.Name == TTTKing then TrackScoreItem:LeftBadge(BadgeStyle.Crown) end -- player is the top leaderboard , future SpeedMaster/ Drift King - badge should be changed according to ScaleUI 
                            else
                                local TrackScoreItem = UIMenuItem.New(race.title,"~HUD_COLOUR_GOLD~Leaderboard King : " .. "N/A" .. "~n~Vehicle                  : " .. "N/A" .. "~n~Time                      : " .. "N/A" .. " s")
                                --TrackScoreItem:LeftBadge(BadgeStyle.RACE_FLAG_PERSON)
                                TrackScoreItem.Activated = function(menu, item)
                                        SetNewWaypoint(DestX, DestY)
                                        --CreateLobbyMenu()
                                      end
                                TimeTrialMenu:AddItem(TrackScoreItem)                        
                            end
						end
						--print(race.title)
                        local TrackScoreItem = UIMenuItem.New(race.title,"~HUD_COLOUR_GOLD~Leaderboard King : " .. "N/A" .. "~n~Vehicle                  : " .. "N/A" .. "~n~Time                      : " .. "N/A" .. " s")
                                --TrackScoreItem:LeftBadge(BadgeStyle.RACE_FLAG_PERSON)
                                TrackScoreItem.Activated = function(menu, item)
                                        SetNewWaypoint(DestX, DestY)
                                        --CreateLobbyMenu()
                                      end
                        TimeTrialMenu:AddItem(TrackScoreItem)                         
				end
			else 
                print("scores nil "..race.title) --debug
                local TrackScoreItem = UIMenuItem.New(race.title, "~HUD_COLOUR_GOLD~Leaderboard King : " .. "N/A" .. "~n~Vehicle                  : " .. "N/A" .. "~n~Time                      : " .. "N/A" .. " s")
				TimeTrialMenu:AddItem(TrackScoreItem)
            end
            print("scores nil "..race.title) --debug
                local TrackScoreItem = UIMenuItem.New(race.title, "~HUD_COLOUR_GOLD~Leaderboard King : " .. "N/A" .. "~n~Vehicle                  : " .. "N/A" .. "~n~Time                      : " .. "N/A" .. " s")
				TimeTrialMenu:AddItem(TrackScoreItem)
		end
	end

    
    --[[
	local uiItemTransitionList = UIMenuListItem.New("Transition",
        { "TRANSITION_OUT", "TRANSITION_UP", "TRANSITION_DOWN" },
        1,
        "Transition type for the big message")
    TimeTrialMenu:AddItem(uiItemTransitionList)

    local uiItemBigMessageManualDispose = UIMenuCheckboxItem.New("Manual Dispose", false,
        "Manually dispose the big message")
    TimeTrialMenu:AddItem(uiItemBigMessageManualDispose)

    local uiItemMessageType = UIMenuListItem.New("Message Type",
        { "Mission Passed", "Coloured Shard", "Old Message", "Simple Shard", "Rank Up", "MP Message Large",
            "MP Wasted Message" }, 1,
        "Message type for the big message, press ~INPUT_FRONTEND_ACCEPT~ to show the message")
    TimeTrialMenu:AddItem(uiItemMessageType)

    local uiItemDisposeBigMessage = UIMenuItem.New("Dispose Big Message", "Dispose the big message")
    TimeTrialMenu:AddItem(uiItemDisposeBigMessage)
	
    local manuallyDisposeBigMessage = false

    TimeTrialMenu.OnCheckboxChange = function(sender, item, checked_)
        if item == uiItemBigMessageManualDispose then
            manuallyDisposeBigMessage = checked_
        end
    end

    TimeTrialMenu.OnItemSelect = function(sender, item, index)
        if item == uiItemDisposeBigMessage then
            ScaleformUI.Scaleforms.BigMessageInstance:Dispose()
        end
    end
	


    TimeTrialMenu.OnListSelect = function(sender, item, index)
        if item == uiItemTransitionList then
            currentTransition = item:IndexToItem(index)
            ScaleformUI.Notifications:ShowNotification(string.format("Transition set to %s", currentTransition))
        elseif item == uiItemMessageType then
            if index == 1 then
                ScaleformUI.Scaleforms.BigMessageInstance:ShowMissionPassedMessage("Mission Passed", 5000,
                    manuallyDisposeBigMessage)
            elseif index == 2 then
                ScaleformUI.Scaleforms.BigMessageInstance:ShowColoredShard("Coloured Shard", "Description",
                    Colours.HUD_COLOUR_WHITE,
                    Colours.HUD_COLOUR_FREEMODE, 5000, manuallyDisposeBigMessage)
            elseif index == 3 then
                ScaleformUI.Scaleforms.BigMessageInstance:ShowOldMessage("Old Message", 5000, manuallyDisposeBigMessage)
            elseif index == 4 then
                ScaleformUI.Scaleforms.BigMessageInstance:ShowSimpleShard("Simple Shard", "Simple Shard Subtitle", 5000,
                    manuallyDisposeBigMessage)
            elseif index == 5 then
                ScaleformUI.Scaleforms.BigMessageInstance:ShowRankupMessage("Rank Up", "Rank Up Subtitle", 10, 5000,
                    manuallyDisposeBigMessage)
            elseif index == 6 then
                ScaleformUI.Scaleforms.BigMessageInstance:ShowMpMessageLarge("MP Message Large", 5000,
                    manuallyDisposeBigMessage)
            elseif index == 7 then
                ScaleformUI.Scaleforms.BigMessageInstance:ShowMpWastedMessage("MP Wasted Message", "Subtitle", 5000,
                    manuallyDisposeBigMessage)
            end
            ScaleformUI.Scaleforms.BigMessageInstance:SetTransition(currentTransition, 0.4, true)
		end
    end ]]--
    -- the new "SwitchTo" method will give your menus the ability to fly
    -- parameters are: UIMenu:SwitchTo([UIMenu]newMenu, [number]newMenuInitialIndex, [bool]inheritPrevMenuParams)
    -- if not specified, the last to parameters will always be [1, false] to allow every menu to be rendered separately
    TimeTrialItem.Activated = function(menu, item)
        menu:SwitchTo(TimeTrialMenu, 1, true)
    end

    
--
		
	local ketchupItem = UIMenuItem.New("Time Trials", animEnabled, 1,
        "So you think you can race ?")
    ketchupItem:LeftBadge(BadgeStyle.RACE_FLAG_CAR) 
    local sidePanel = UIMissionDetailsPanel.New(1, "Time Trials", 6, true, "scaleformui", "timetrials")
	
	local detailDesc = UIMenuFreemodeDetailsItem.New("Time Trials")
	
	
    
	local detailItem1 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRIEFCASE, Colours.HUD_COLOUR_FREEMODE, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
    local detailItem2 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.STAR, Colours.HUD_COLOUR_GOLD, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
    local detailItem3 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.ARMOR, Colours.HUD_COLOUR_PURPLE, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
    local detailItem4 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRAND_DILETTANTE, Colours.HUD_COLOUR_GREEN, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
    local detailItem5 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.COUNTRY_GERMANY, Colours.HUD_COLOUR_WHITE, true, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
	local detailItem6 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", true)
    local detailItem7 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false)
	local detailDesc = UIMenuFreemodeDetailsItem.New("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat")
	detailItem1:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem2:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem3:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem4:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem5:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem6:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem7:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailDesc:SetLabelsFonts(ScaleformFonts.SIGNPAINTER_HOUSESCRIPT)

    sidePanel:AddItem(detailItem1)
    sidePanel:AddItem(detailItem2)
    sidePanel:AddItem(detailItem3)
    sidePanel:AddItem(detailItem4)
    sidePanel:AddItem(detailItem5)
    sidePanel:AddItem(detailItem6)
    sidePanel:AddItem(detailItem7)
    sidePanel:AddItem(detailDesc)


    ketchupItem:AddSidePanel(sidePanel)
    RaceMenu:AddItem(ketchupItem)

    local animations = {}
    for k, v in pairs(MenuAnimationType) do
        -- table.insert(animations, k) -- Instead of this , use it like below (learn more here : https://springrts.com/wiki/Lua_Performance#TEST_12:_Adding_Table_Items_.28table.insert_vs._.5B_.5D.29)
        animations[#animations + 1] = k
    end

    local scrollingAnimationItem = UIMenuListItem.New("Choose the scrolling animation", animations, RaceMenu:AnimationType(),
        "~BLIP_BARBER~ ~BLIP_INFO_ICON~ ~BLIP_TANK~ ~BLIP_OFFICE~ ~BLIP_CRIM_DRUGS~ ~BLIP_WAYPOINT~ ~INPUTGROUP_MOVE~~n~You can use Blips and Inputs in description as you prefer!~n~⚠ 🐌 ❤️ 🥺 💪🏻 You can use Emojis too!"
        , Colours.HUD_COLOUR_FREEMODE_DARK, Colours.HUD_COLOUR_FREEMODE)
    scrollingAnimationItem:BlinkDescription(true)
    RaceMenu:AddItem(scrollingAnimationItem)

	local scrollItem = UIMenuListItem.New("Choose how this menu will ~o~scroll~s~!", { "CLASSIC", "PAGINATED", "ENDLESS" }, RaceMenu:ScrollingType())
    RaceMenu:AddItem(scrollItem)

    scrollItem.OnListChanged = function (menu, item, index)
		menu:ScrollingType(index)
    end

    local cookItem = UIMenuItem.New("Cook!", "Cook the dish with the appropiate ingredients and ketchup.")
    RaceMenu:AddItem(cookItem)
	cookItem:LeftBadge(BadgeStyle.STAR)
	cookItem:RightLabel("RightLabel in GTA font")
	cookItem:LabelFont(ScaleformFonts.ENGRAVERS_OLD_ENGLISH_MT_STD)
	cookItem:RightLabelFont(ScaleformFonts.PRICEDOWN_GTAV_INT)

	RaceMenu.OnItemSelect = function(menu, item, index)
        if (item == cookItem) then
            ScaleformUI.Notifications:ShowNotification("We're cooking Jessie!")
        end
        ScaleformUI.Notifications:ShowNotification("Item with label '" .. item:Label() .. "' was clicked.")
    end

    local colorItem = UIMenuItem.New("~HUD_COLOUR_FREEMODE~UIMenuItem ~w~with ~HUD_COLOUR_ORANGELIGHT~Colors", "~b~Look!!~r~I can be colored ~y~too!!~w~", 21, 24)
    colorItem:LeftBadge(BadgeStyle.STAR)
    RaceMenu:AddItem(colorItem)
    local sidePanelVehicleColor = UIVehicleColorPickerPanel.New(1, "ColorPicker", 6)
    colorItem:AddSidePanel(sidePanelVehicleColor)

    local dynamicValue = 0
    local dynamicListItem = UIMenuDynamicListItem.New("Dynamic List Item",
        "Try pressing ~INPUT_FRONTEND_LEFT~ or ~INPUT_FRONTEND_RIGHT~", tostring(dynamicValue),
        function(item, direction)
            if (direction == "left") then
                dynamicValue = dynamicValue - 1
            elseif (direction == "right") then
                dynamicValue = dynamicValue + 1
            end
            return tostring(dynamicValue)
        end)
    RaceMenu:AddItem(dynamicListItem)
    dynamicListItem:LeftBadge(BadgeStyle.STAR)

    local seperatorItem1 = UIMenuSeparatorItem.New("Separator (Jumped)", true)
    local seperatorItem2 = UIMenuSeparatorItem.New("Separator (not Jumped)", false)
    RaceMenu:AddItem(seperatorItem1)
    RaceMenu:AddItem(seperatorItem2)

    local foodsList     = { "Banana", "<C>Apple</C>", "Pizza", "Quartilicious" }
    local colorListItem = UIMenuListItem.New("Colored ListItem.. Really?", foodsList, 0,
        "~BLIP_BARBER~ ~BLIP_INFO_ICON~ ~BLIP_TANK~ ~BLIP_OFFICE~ ~BLIP_CRIM_DRUGS~ ~BLIP_WAYPOINT~ ~INPUTGROUP_MOVE~~n~You can use Blips and Inputs in description as you prefer!" --radar_race_air
        , 21, 24)
    RaceMenu:AddItem(colorListItem)

    local sliderItem = UIMenuSliderItem.New("Slider Item!", 100, 5, 50, false, "Cool!")
    RaceMenu:AddItem(sliderItem)
    local progressItem = UIMenuProgressItem.New("Slider Progress Item", 10, 5)
    RaceMenu:AddItem(progressItem)

    local listPanelItem1 = UIMenuItem.New("Change Color", "It can be whatever item you want it to be")
    local colorPanel = UIMenuColorPanel.New("Color Panel Example", 1, 0)
    local colorPanel2 = UIMenuColorPanel.New("Custom Palette Example", 1, 0,
        { "HUD_COLOUR_GREEN", "HUD_COLOUR_RED", "HUD_COLOUR_FREEMODE", "HUD_COLOUR_PURPLE", "HUD_COLOUR_TREVOR" })
    RaceMenu:AddItem(listPanelItem1)
    listPanelItem1:AddPanel(colorPanel)
    listPanelItem1:AddPanel(colorPanel2)

    local listPanelItem2 = UIMenuItem.New("Change Percentage", "It can be whatever item you want it to be")
    local percentagePanel = UIMenuPercentagePanel.New("Percentage Panel Example", "0%", "100%")
    RaceMenu:AddItem(listPanelItem2)
    listPanelItem2:AddPanel(percentagePanel)

    local listPanelItem3 = UIMenuItem.New("Change Grid Position", "It can be whatever item you want it to be")
    local gridPanel = UIMenuGridPanel.New("Up", "Left", "Right", "Down", vector2(0.5, 0.5), 0)
    local horizontalGridPanel = UIMenuGridPanel.New("", "Left", "Right", "", vector2(0.5, 0.5), 1)
    RaceMenu:AddItem(listPanelItem3)
    listPanelItem3:AddPanel(gridPanel)
    listPanelItem3:AddPanel(horizontalGridPanel)

    local listPanelItem4 = UIMenuListItem.New("Look at Statistics", { "Example", "example2" }, 0)
    local statisticsPanel = UIMenuStatisticsPanel.New()
    statisticsPanel:AddStatistic("Look at this!", 10.0)
    statisticsPanel:AddStatistic("I'm a statistic too!", 50.0)
    statisticsPanel:AddStatistic("Am i not?!", 100.0)
    RaceMenu:AddItem(listPanelItem4)
    listPanelItem4:AddPanel(statisticsPanel)

    listPanelItem4.OnListChanged = function(menu, item, newIndex)
        if (newIndex == 1) then
            ScaleformUI.Notifications:ShowNotification("Update Statistics Panel Item 1")
            statisticsPanel:UpdateStatistic(1, 10.0)
            statisticsPanel:UpdateStatistic(2, 50.0)
            statisticsPanel:UpdateStatistic(3, 100.0)
        elseif (newIndex == 2) then
            ScaleformUI.Notifications:ShowNotification("Update Statistics Panel Item 2")
            statisticsPanel:UpdateStatistic(1, 100.0)
            statisticsPanel:UpdateStatistic(2, 75.0)
            statisticsPanel:UpdateStatistic(3, 25.0)
        end
    end

    local windowMenu = UIMenu.New("Windows Submenu", "it is a totally separated menu now")
    local windowItem = UIMenuItem.New("Windows item", "Yeah created on its own and handled on item selection")
    windowItem:RightLabel("~HUD_COLOUR_DEGEN_CYAN~>>>")
    RaceMenu:AddItem(windowItem)
    local heritageWindow = UIMenuHeritageWindow.New(0, 0)
    local detailsWindow = UIMenuDetailsWindow.New("Parents resemblance", "Dad:", "Mom:", true, {})
    windowMenu:AddWindow(heritageWindow)
    windowMenu:AddWindow(detailsWindow)
    local momNames           = { "Hannah", "Audrey", "Jasmine", "Giselle", "Amelia", "Isabella", "Zoe", "Ava", "Camilla",
        "Violet",
        "Sophia", "Eveline", "Nicole", "Ashley", "Grace", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte",
        "Emma", "Misty" }
    local dadNames           = { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Joan", "Alex", "Isaac", "Evan",
        "Ethan",
        "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony",
        "Claude", "Niko", "John" }

    local momListItem        = UIMenuListItem.New("Mom", momNames, 0)
    local dadListItem        = UIMenuListItem.New("Dad", dadNames, 0)
    local heritageSliderItem = UIMenuSliderItem.New("Heritage Slider", 100, 5, 0, true, "This is Useful on heritage")
    windowMenu:AddItem(momListItem)
    windowMenu:AddItem(dadListItem)
    windowMenu:AddItem(heritageSliderItem)

    detailsWindow.DetailMid = "Dad: " .. heritageSliderItem:Index() .. "%"
    detailsWindow.DetailBottom = "Mom: " .. (100 - heritageSliderItem:Index()) .. "%"
    detailsWindow.DetailStats = {
        {
            Percentage = 100,
            HudColor = 6
        },
        {
            Percentage = 0,
            HudColor = 50
        }
    }

    detailsWindow:UpdateStatsToWheel()

    -- parameters are: UIMenu:SwitchTo([UIMenu]newMenu, [number]newMenuInitialIndex, [bool]inheritPrevMenuParams)
    -- if not specified, the last to parameters will always be [1, false] to allow every menu to be rendered separately
    windowItem.Activated = function(menu, item)
        menu:SwitchTo(windowMenu, 1, true) 
    end

    RaceMenu.OnMenuOpen = function(menu)
		print("Menu opened!")
    end
    RaceMenu.OnMenuClose = function(menu)
        print("Menu closed!")
    end

    ketchupItem.OnCheckboxChanged = function(menu, item, checked)
        sidePanel:UpdatePanelTitle(tostring(checked))
        menu:AnimationEnabled(checked)
        scrollingAnimationItem:Enabled(checked)
        if checked then
            scrollingAnimationItem:LeftBadge(BadgeStyle.NONE)
        else
            scrollingAnimationItem:LeftBadge(1)
        end
    end

    scrollingAnimationItem.OnListChanged = function(menu, item, index)
        menu:AnimationType(index)
    end

    colorPanel.OnColorPanelChanged = function(menu, item, newindex)
        print(newindex)
        local message = "ColorPanel index => " .. newindex + 1
        AddTextEntry("ScaleformUINotification", message)
        BeginTextCommandThefeedPost("ScaleformUINotification")
        EndTextCommandThefeedPostTicker(false, true)
    end

    colorPanel2.OnColorPanelChanged = function(menu, item, newindex)
        local message = "ColorPanel2 index => " .. newindex + 1
        AddTextEntry("ScaleformUINotification", message)
        BeginTextCommandThefeedPost("ScaleformUINotification")
        EndTextCommandThefeedPostTicker(false, true)
    end

    percentagePanel.OnPercentagePanelChange = function(menu, item, newpercentage)
        local message = "PercentagePanel => " .. newpercentage
        ScaleformUI.Notifications:ShowSubtitle(message)
    end

    gridPanel.OnGridPanelChanged = function(menu, item, newposition)
        local message = "PercentagePanel => " .. newposition
        ScaleformUI.Notifications:ShowSubtitle(message)
    end

    horizontalGridPanel.OnGridPanelChanged = function(menu, item, newposition)
        local message = "PercentagePanel => " .. newposition
        ScaleformUI.Notifications:ShowSubtitle(message)
    end

    sidePanelVehicleColor.PickerSelect = function(menu, item, newindex)
        local message = "ColorPanel index => " .. newindex + 1
        ScaleformUI.Notifications:ShowNotification(message)
    end

    local MomIndex = 0
    local DadIndex = 0

    windowMenu.OnListChange = function(menu, item, newindex)
        if (item == momListItem) then
            MomIndex = newindex
        elseif (item == dadListItem) then
            DadIndex = newindex
        end
        heritageWindow:Index(MomIndex, DadIndex)
    end

    heritageSliderItem.OnSliderChanged = function(menu, item, value)
        detailsWindow.DetailStats[1].Percentage = 100 - value
        detailsWindow.DetailStats[2].Percentage = value
        detailsWindow:UpdateStatsToWheel()
        detailsWindow:UpdateLabels("Parents resemblance", "Dad: " .. value .. "%", "Mom: " .. (100 - value) .. "%")
    end

    RaceMenu:Visible(true)
	RaceMenu:Title("Scaleform~HUD_COLOUR_PURPLE~UI")
	RaceMenu:Subtitle("~p~Colored ~HUD_COLOUR_ORANGE~Subtitle")
end

function Arta.LSCustoms()
    local txd = CreateRuntimeTxd("scaleformui")
    local duiPanel = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160)
    CreateRuntimeTextureFromDuiHandle(txd, "sidepanel", GetDuiHandle(duiPanel))
	local duiBanner = CreateDui("https://i.imgur.com/3yrFYbF.gif", 288, 160)
	CreateRuntimeTextureFromDuiHandle(txd, "menuBanner", GetDuiHandle(duiBanner))

    local CustomsMainMenu = UIMenu.New("LS Customs", "Powered by Awesome ScaleformUI", 50, 50, true, "scaleformui", "menuBanner", true)
    CustomsMainMenu:MaxItemsOnScreen(7)
    CustomsMainMenu:MouseControlsEnabled(true)
    CustomsMainMenu:MouseEdgeEnabled(false)
    CustomsMainMenu:ControlDisablingEnabled(true)
    CustomsMainMenu:BuildingAnimation(MenuBuildingAnimation.RIGHT)
    CustomsMainMenu:AnimationType(MenuAnimationType.CUBIC_INOUT)
	CustomsMainMenu:ScrollingType(MenuScrollingType.CLASSIC)
	CustomsMainMenu:CounterColor(Colours.HUD_COLOUR_YELLOW)

    local PaintshopMMItem = UIMenuItem.New("Paintshop","Paint it")
    CustomsMainMenu.AddItem(PaintshopMMItem)
   
    PaintshopMMItem.Activated = function(menu, item)
        Arta.PaintshopMenu()
    end
end

function Arta.PaintshopMenu()
    local txd = CreateRuntimeTxd("scaleformui")
    local duiPanel = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160)
    CreateRuntimeTextureFromDuiHandle(txd, "sidepanel", GetDuiHandle(duiPanel))
	local duiBanner = CreateDui("https://i.imgur.com/3yrFYbF.gif", 288, 160)
	CreateRuntimeTextureFromDuiHandle(txd, "menuBanner", GetDuiHandle(duiBanner))

    local PaintshopMMenu = UIMenu.New("Paintshop", "Powered by Awesome ScaleformUI", 50, 50, true, "scaleformui", "menuBanner", true)
    PaintshopMMenu:MaxItemsOnScreen(7)
    PaintshopMMenu:MouseControlsEnabled(true)
    PaintshopMMenu:MouseEdgeEnabled(false)
    PaintshopMMenu:ControlDisablingEnabled(true)
    PaintshopMMenu:BuildingAnimation(MenuBuildingAnimation.RIGHT)
    PaintshopMMenu:AnimationType(MenuAnimationType.CUBIC_INOUT)
	PaintshopMMenu:ScrollingType(MenuScrollingType.CLASSIC)
	PaintshopMMenu:CounterColor(Colours.HUD_COLOUR_YELLOW)

    local colorpanel = UIVehicleColorPickerPanel.New(side, title, color)

    colorpanel.PickerSelect = function(item, panel, colorIndex)
    --

end

function CreateLobbyMenu()
    local lobbyMenu = MainView.New("Lobby Menu", "ScaleformUI for you by Manups4e!", "Detail 1", "Detail 2", "Detail 3")
    local columns = {
        SettingsListColumn.New("COLUMN SETTINGS", Colours.HUD_COLOUR_RED),
        PlayerListColumn.New("COLUMN PLAYERS", Colours.HUD_COLOUR_ORANGE),
        MissionDetailsPanel.New("COLUMN INFO PANEL", Colours.HUD_COLOUR_GREEN),
    }
    lobbyMenu:SetupColumns(columns)

    local handle = RegisterPedheadshot(PlayerPedId())
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do Citizen.Wait(0) end
    local txd = GetPedheadshotTxdString(handle)
    lobbyMenu:HeaderPicture(txd, txd) 	-- lobbyMenu:CrewPicture used to add a picture on the left of the HeaderPicture

    UnregisterPedheadshot(handle) -- call it right after adding the menu.. this way the txd will be loaded correctly by the scaleform.. 

    lobbyMenu:CanPlayerCloseMenu(true)
    -- this is just an example..CanPlayerCloseMenu is always defaulted to true.. if you set this to false.. be sure to give the players a way out of your menu!!! 
    local item = UIMenuItem.New("UIMenuItem", "UIMenuItem description")
    local item1 = UIMenuListItem.New("UIMenuListItem", { "This", "is", "a", "Test"}, 0, "UIMenuListItem description")
    local item2 = UIMenuCheckboxItem.New("UIMenuCheckboxItem", true, 1, "UIMenuCheckboxItem description")
    local item3 = UIMenuSliderItem.New("UIMenuSliderItem", 100, 5, 50, false, "UIMenuSliderItem description")
    local item4 = UIMenuProgressItem.New("UIMenuProgressItem", 10, 5, "UIMenuProgressItem description")
    item:BlinkDescription(true)
    lobbyMenu.SettingsColumn:AddSettings(item)
    lobbyMenu.SettingsColumn:AddSettings(item1)
    lobbyMenu.SettingsColumn:AddSettings(item2)
    lobbyMenu.SettingsColumn:AddSettings(item3)
    lobbyMenu.SettingsColumn:AddSettings(item4)

    local friend = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_GREEN, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
    local friend1 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_MENU_YELLOW, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
    local friend2 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_PINK, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
    local friend3 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_BLUE, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
    local friend4 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_ORANGE, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
    local friend5 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_RED, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
    friend:SetLeftIcon(LobbyBadgeIcon.IS_CONSOLE_PLAYER, false)
    friend1:SetLeftIcon(LobbyBadgeIcon.IS_PC_PLAYER, false)
    friend2:SetLeftIcon(LobbyBadgeIcon.SPECTATOR, false)
    friend3:SetLeftIcon(LobbyBadgeIcon.INACTIVE_HEADSET, false)
    friend4:SetLeftIcon(BadgeStyle.COUNTRY_ITALY, true)
    friend5:SetLeftIcon(BadgeStyle.CASTLE, true)

    friend:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
    friend1:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
    friend2:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
    friend3:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
    friend4:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
    friend5:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu

    local panel = PlayerStatsPanel.New("Player 1", Colours.HUD_COLOUR_GREEN)
    panel:Description("This is the description for Player 1!!")
    panel:HasPlane(true)
    panel:HasHeli(true)
    panel.RankInfo:RankLevel(150)
    panel.RankInfo:LowLabel("This is the low label")
    panel.RankInfo:MidLabel("This is the middle label")
    panel.RankInfo:UpLabel("This is the upper label")
    panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
    panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
    panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
    panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
    panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
    friend:AddPanel(panel)

    local panel1 = PlayerStatsPanel.New("Player 2", Colours.HUD_COLOUR_MENU_YELLOW)
    panel1:Description("This is the description for Player 2!!")
    panel1:HasPlane(true)
    panel1:HasVehicle(true)
    panel1.RankInfo:RankLevel(70)
    panel1.RankInfo:LowLabel("This is the low label")
    panel1.RankInfo:MidLabel("This is the middle label")
    panel1.RankInfo:UpLabel("This is the upper label")
    panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
    panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
    panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
    panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
    panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
    friend1:AddPanel(panel1)

    local panel2 = PlayerStatsPanel.New("Player 3", Colours.HUD_COLOUR_PINK)
    panel2:Description("This is the description for Player 3!!")
    panel2:HasPlane(true)
    panel2:HasHeli(true)
    panel2:HasVehicle(true)
    panel2.RankInfo:RankLevel(15)
    panel2.RankInfo:LowLabel("This is the low label")
    panel2.RankInfo:MidLabel("This is the middle label")
    panel2.RankInfo:UpLabel("This is the upper label")
    panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
    panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
    panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
    panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
    panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
    friend2:AddPanel(panel2)

    local panel3 = PlayerStatsPanel.New("Player 4", Colours.HUD_COLOUR_FREEMODE)
    panel3:Description("This is the description for Player 4!!")
    panel3:HasPlane(true)
    panel3:HasHeli(true)
    panel3:HasBoat(true)
    panel3.RankInfo:RankLevel(10)
    panel3.RankInfo:LowLabel("This is the low label")
    panel3.RankInfo:MidLabel("This is the middle label")
    panel3.RankInfo:UpLabel("This is the upper label")
    panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
    panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
    panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
    panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
    panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
    friend3:AddPanel(panel3)

    local panel4 = PlayerStatsPanel.New("Player 5", Colours.HUD_COLOUR_ORANGE)
    panel4:Description("This is the description for Player 5!!")
    panel4:HasPlane(true)
    panel4:HasHeli(true)
    panel4.RankInfo:RankLevel(1000)
    panel4.RankInfo:LowLabel("This is the low label")
    panel4.RankInfo:MidLabel("This is the middle label")
    panel4.RankInfo:UpLabel("This is the upper label")
    panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
    panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
    panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
    panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
    panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
    friend4:AddPanel(panel4)

    local panel5 = PlayerStatsPanel.New("Player 6", Colours.HUD_COLOUR_RED)
    panel5:Description("This is the description for Player 6!!")
    panel5:HasPlane(true)
    panel5:HasHeli(true)
    panel5.RankInfo:RankLevel(22)
    panel5.RankInfo:LowLabel("This is the low label")
    panel5.RankInfo:MidLabel("This is the middle label")
    panel5.RankInfo:UpLabel("This is the upper label")
    panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
    panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
    panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
    panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
    panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
    friend5:AddPanel(panel5)

    lobbyMenu.PlayersColumn:AddPlayer(friend)
    lobbyMenu.PlayersColumn:AddPlayer(friend1)
    lobbyMenu.PlayersColumn:AddPlayer(friend2)
    lobbyMenu.PlayersColumn:AddPlayer(friend3)
    lobbyMenu.PlayersColumn:AddPlayer(friend4)
    lobbyMenu.PlayersColumn:AddPlayer(friend5)

    
    local txd = CreateRuntimeTxd("scaleformui");
    local _paneldui = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160)
    CreateRuntimeTextureFromDuiHandle(txd, "lobby_panelbackground", GetDuiHandle(_paneldui))

    lobbyMenu.MissionPanel:UpdatePanelPicture("scaleformui", "lobby_panelbackground")
    lobbyMenu.MissionPanel:Title("ScaleformUI - Title")
    local detailItem1 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRIEFCASE, Colours.HUD_COLOUR_FREEMODE)
    local detailItem2 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.STAR, Colours.HUD_COLOUR_GOLD)
    local detailItem3 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.ARMOR, Colours.HUD_COLOUR_PURPLE)
    local detailItem4 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRAND_DILETTANTE, Colours.HUD_COLOUR_GREEN)
    local detailItem5 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.COUNTRY_ITALY, Colours.HUD_COLOUR_WHITE, true)
    local detailItem6 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", true)
    local detailItem7 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false)
    --local missionItem4 = new("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "", false)
    lobbyMenu.MissionPanel:AddItem(detailItem1)
    lobbyMenu.MissionPanel:AddItem(detailItem2)
    lobbyMenu.MissionPanel:AddItem(detailItem3)
    lobbyMenu.MissionPanel:AddItem(detailItem4)
    lobbyMenu.MissionPanel:AddItem(detailItem5)
    lobbyMenu.MissionPanel:AddItem(detailItem6)
    lobbyMenu.MissionPanel:AddItem(detailItem7)

    lobbyMenu.SettingsColumn.OnIndexChanged = function(idx)
        ScaleformUI.Notifications:ShowSubtitle("SettingsColumn index =>~b~ ".. idx .. "~w~.")
    end

    lobbyMenu.PlayersColumn.OnIndexChanged = function(idx)
        ScaleformUI.Notifications:ShowSubtitle("PlayersColumn index =>~b~ ".. idx .. "~w~.")
    end

    lobbyMenu:Visible(true)
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		

		if IsControlJustPressed(0, 52) and not MenuHandler:IsAnyMenuOpen() then -- F5/Q
			Arta.MainMenu()
		end
		

		-- this is used to free memory from all the menus in the MenuHandler emptying its tables.
		-- YOU WILL NEED TO REBUILD YOUR MENUS IN CODE TO MAKE THEM WORK AGAIN!
		if IsControlJustPressed(0, 47) then -- G
			local Enter = InstructionalButton.New('Enter', -1, 191, 191, -1)
			ScaleformUI.Scaleforms.Warning:ShowWarningWithButtons("Title", "Subtitle", "Prompt", {Enter}, "Error message", 0)
			ScaleformUI.Scaleforms.Warning.OnButtonPressed = function(button)
				print(button.Text .. " button has been pressed.")
			end
			--ScaleformUI.Scaleforms.Warning:ShowWarning("This is the title", "This is the subtitle", "This is the prompt.. you have 6 seconds left", "This is the error message, ScaleformUI Ver. 3.0", 0, false)
		end
	end
end)