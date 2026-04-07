pcall(function()

if not game.Players.LocalPlayer.Character or game.Players.LocalPlayer.Character:WaitForChild("Humanoid").RigType ~= Enum.HumanoidRigType.R15 then 
    game.StarterGui:SetCore("SendNotification", {Title = "R6", Text = "You're on R6, bro. Change to R15!", Duration = 60})
    return
end

local st = os.clock()
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local camera = workspace.CurrentCamera

cloneref = cloneref or function(o) return o end

-- Capture default animations BEFORE any changes are made
local defaultAnimIds = {}
local function captureDefaults()
    local char = Players.LocalPlayer.Character
    if not char then return false end
    local animate = char:FindFirstChild("Animate")
    if not animate then return false end
    pcall(function()
        defaultAnimIds.Idle     = {
            animate.idle.Animation1.AnimationId,
            animate.idle.Animation2.AnimationId
        }
        defaultAnimIds.Walk     = animate.walk.WalkAnim.AnimationId
        defaultAnimIds.Run      = animate.run.RunAnim.AnimationId
        defaultAnimIds.Jump     = animate.jump.JumpAnim.AnimationId
        defaultAnimIds.Fall     = animate.fall.FallAnim.AnimationId
        defaultAnimIds.Climb    = animate.climb.ClimbAnim.AnimationId
        if animate:FindFirstChild("swim") then
            defaultAnimIds.Swim = animate.swim.Swim.AnimationId
        end
        if animate:FindFirstChild("swimidle") then
            defaultAnimIds.SwimIdle = animate.swimidle.SwimIdle.AnimationId
        end
    end)
    return defaultAnimIds.Walk ~= nil
end

-- Try to capture now, or wait for character
if not captureDefaults() then
    Players.LocalPlayer.CharacterAdded:Wait()
    task.wait(0.5)
    captureDefaults()
end
local GazeGoGui = cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Notifbro = {}
function Notify(titletxt, text, time)
    coroutine.wrap(function()
        local GUI = Instance.new("ScreenGui")
        local Main = Instance.new("Frame", GUI)
        local title = Instance.new("TextLabel", Main)
        local message = Instance.new("TextLabel", Main)

        GUI.Name = "BackgroundNotif"
        GUI.Parent = GazeGoGui

        local sw = workspace.CurrentCamera.ViewportSize.X
        local sh = workspace.CurrentCamera.ViewportSize.Y
        local nh = sh / 7
        local nw = sw / 5

        Main.Name = "MainFrame"
        Main.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        Main.BackgroundTransparency = 0.2
        Main.BorderSizePixel = 0
        Main.Size = UDim2.new(0, nw, 0, nh)

        title.BackgroundColor3 = Color3.new(0, 0, 0)
        title.BackgroundTransparency = 0.9
        title.Size = UDim2.new(1, 0, 0, nh / 2)
        title.Font = Enum.Font.GothamBold
        title.Text = titletxt
        title.TextColor3 = Color3.new(1, 1, 1)
        title.TextScaled = true

        message.BackgroundColor3 = Color3.new(0, 0, 0)
        message.BackgroundTransparency = 1
        message.Position = UDim2.new(0, 0, 0, nh / 2)
        message.Size = UDim2.new(1, 0, 1, -nh / 2)
        message.Font = Enum.Font.Gotham
        message.Text = text
        message.TextColor3 = Color3.new(1, 1, 1)
        message.TextScaled = true

        local offset = 50
        for _, notif in ipairs(Notifbro) do
            offset = offset + notif.Size.Y.Offset + 10
        end

        Main.Position = UDim2.new(1, 5, 0, offset)
        table.insert(Notifbro, Main)

        task.wait(0.1)
        Main:TweenPosition(UDim2.new(1, -nw, 0, offset), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
        Main:TweenSize(UDim2.new(0, nw * 1.06, 0, nh * 1.06), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.5, true)
        task.wait(0.1)
        Main:TweenSize(UDim2.new(0, nw, 0, nh), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.2, true)

        task.wait(time)

        Main:TweenSize(UDim2.new(0, nw * 1.06, 0, nh * 1.06), Enum.EasingDirection.In, Enum.EasingStyle.Elastic, 0.2, true)
        task.wait(0.2)
        Main:TweenSize(UDim2.new(0, nw, 0, nh), Enum.EasingDirection.In, Enum.EasingStyle.Elastic, 0.2, true)
        task.wait(0.2)
        Main:TweenPosition(UDim2.new(1, 5, 0, offset), Enum.EasingDirection.In, Enum.EasingStyle.Bounce, 0.5, true)
        task.wait(0.1)

        GUI:Destroy()
        for i, notif in ipairs(Notifbro) do
            if notif == Main then
                table.remove(Notifbro, i)
                break
            end
        end

        for i, notif in ipairs(Notifbro) do
            local newOffset = 50 + (nh + 10) * (i - 1)
            notif:TweenPosition(UDim2.new(1, -nw, 0, newOffset), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
        end
    end)()
end

task.wait(0.1)

local guiName = "GazeVerificator"
if GazeGoGui:FindFirstChild(guiName) then
    Notify("Error","Script Already Executed", 1)
    return
end

local function getScaledSize(relativeWidth, relativeHeight)
    local viewportSize = camera.ViewportSize
    return UDim2.new(0, math.floor(viewportSize.X * relativeWidth), 0, math.floor(viewportSize.Y * relativeHeight))
end

local core = cloneref(game.CoreGui)
local old = core:FindFirstChild("DraggableGui")
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DraggableGui"
screenGui.Parent = core

-- TALLER WINDOW SIZE - Changed from 0.4 to 0.6 height for more buttons
local frame = Instance.new("TextButton")
frame.Name = "GazeBro"
frame.Text = ""
frame.Size = getScaledSize(0.3, 0.6) -- TALLER: 60% of screen height instead of 40%
frame.Position = UDim2.new(0.5, -getScaledSize(0.3,0.6).X.Offset/2, 0.5, -getScaledSize(0.3,0.6).Y.Offset/2)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0  -- Remove border for rounded corners
frame.ClipsDescendants = true
frame.Active = true
frame.Draggable = true

-- Add rounded corners to main frame
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)  -- Curved edges
UICorner.Parent = frame

frame.Parent = screenGui

local holding = false
local startTime = 0
local startPos

local function fadeOut()
    local t = frame.BackgroundTransparency
    while t < 1 do
        if t < 0.7 then
            t = t + 0.05
        else
            t = t + 0.015
        end
        if t > 1 then t = 1 end
        frame.BackgroundTransparency = t
        task.wait(0.02)
    end
end

local function fadeIn()
    local t = frame.BackgroundTransparency
    while t > 0.2 do
        if t > 0.7 then
            t = t - 0.015
        else
            t = t - 0.05
        end
        if t < 0.2 then t = 0.2 end
        frame.BackgroundTransparency = t
        task.wait(0.02)
    end
end

local function movedFar()
    local currentPos = frame.AbsolutePosition
    local dx = math.abs(currentPos.X - startPos.X)
    local dy = math.abs(currentPos.Y - startPos.Y)
    return dx >= 20 or dy >= 20
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        holding = true
        startTime = os.clock()
        startPos = frame.AbsolutePosition
        
        -- Use heartbeat instead of tight loop
        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not holding then
                connection:Disconnect()
                return
            end
            
            if movedFar() then
                holding = false
                connection:Disconnect()
                return
            end
            
            if os.clock() - startTime >= 3 then
                if frame.BackgroundTransparency < 1 then
                    fadeOut()
                else
                    fadeIn()
                end
                holding = false
                connection:Disconnect()
            end
        end)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        holding = false
    end
end)

local searchBar = Instance.new("TextBox")
searchBar.Name = "SearchBar"
searchBar.Text = ""
searchBar.PlaceholderText = "Search..."
searchBar.Font = Enum.Font.SourceSans
searchBar.TextScaled = true
searchBar.TextColor3 = Color3.fromRGB(200, 200, 200)
searchBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
searchBar.BorderSizePixel = 0
searchBar.Size = UDim2.new(0.9, 0, 0.1, 0) -- Smaller search bar to make room for more buttons
searchBar.Position = UDim2.new(0.05, 0, 0.05, 0) -- Adjusted position
searchBar.ClearTextOnFocus = true

-- Add rounded corners to search bar
local searchBarCorner = Instance.new("UICorner")
searchBarCorner.CornerRadius = UDim.new(0, 8)
searchBarCorner.Parent = searchBar

searchBar.Parent = frame

-- FULL SET MODE TOGGLE BUTTON
local isFullSetMode = false

local fullSetBtn = Instance.new("TextButton")
fullSetBtn.Name = "FullSetBtn"
fullSetBtn.Text = "⚡ Full Set: OFF"
fullSetBtn.Font = Enum.Font.GothamBold
fullSetBtn.TextScaled = true
fullSetBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
fullSetBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
fullSetBtn.BorderSizePixel = 0
fullSetBtn.Size = UDim2.new(0.6, 0, 0.06, 0)
fullSetBtn.Position = UDim2.new(0.05, 0, 0.16, 0)

local fullSetBtnCorner = Instance.new("UICorner")
fullSetBtnCorner.CornerRadius = UDim.new(0, 8)
fullSetBtnCorner.Parent = fullSetBtn

fullSetBtn.Parent = frame

-- RESET TO DEFAULT BUTTON
local resetBtn = Instance.new("TextButton")
resetBtn.Name = "ResetBtn"
resetBtn.Text = "🔄 Reset"
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextScaled = true
resetBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
resetBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
resetBtn.BorderSizePixel = 0
resetBtn.Size = UDim2.new(0.28, 0, 0.06, 0)
resetBtn.Position = UDim2.new(0.67, 0, 0.16, 0)

local resetBtnCorner = Instance.new("UICorner")
resetBtnCorner.CornerRadius = UDim.new(0, 8)
resetBtnCorner.Parent = resetBtn

resetBtn.Parent = frame

-- LARGER SCROLL FRAME - More space for buttons
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(0.9, 0, 0.73, 0) -- Slightly shorter to make room for Full Set button
scrollFrame.Position = UDim2.new(0.05, 0, 0.23, 0) -- Below Full Set button
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6 -- Added scrollbar for better navigation
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarImageTransparency = 0.3 -- Visible scrollbar

-- Add rounded corners to scroll frame
local scrollFrameCorner = Instance.new("UICorner")
scrollFrameCorner.CornerRadius = UDim.new(0, 8)
scrollFrameCorner.Parent = scrollFrame

scrollFrame.Parent = frame

-- LAZY LOADING VARIABLES
local buttons = {}
local createdSet = {}
local animationsLoaded = false
local Animations = {}
local buttonPool = {}
local buttonConnections = {} -- FIX: Store connections to manage them properly
local visibleButtonCount = 15 -- Only show 15 buttons at once
local currentScrollPosition = 0

-- UPDATED ANIMATION DATABASE (UGC entries removed, [VOTE] entries kept)
local function loadAnimations()
    if animationsLoaded then return Animations end
    
    local OriginalAnimations = {
        ["Idle"] = {
            ["Astronaut"] = {"891621366", "891633237"},
            ["Adidas Community"] = {"122257458498464", "102357151005774"},
            ["Bold"] = {"16738333868", "16738334710"},
            ["Borock"] = {"3293641938", "3293642554"},
            ["Bubbly"] = {"910004836", "910009958"},
            ["Cartoony"] = {"742637544", "742638445"},
            ["Confident"] = {"1069977950", "1069987858"},
            ["Catwalk Glam"] = {"133806214992291", "94970088341563"},
            ["Cowboy"] = {"1014390418", "1014398616"},
            ["Elder"] = {"10921101664", "10921102574"},
            ["Ghost"] = {"616006778", "616008087"},
            ["Knight"] = {"657595757", "657568135"},
            ["Levitation"] = {"616006778", "616008087"},
            ["Mage"] = {"707742142", "707855907"},
            ["MrToilet"] = {"4417977954", "4417978624"},
            ["Ninja"] = {"656117400", "656118341"},
            ["NFL"] = {"92080889861410", "74451233229259"},
            ["OldSchool"] = {"10921230744", "10921232093"},
            ["Patrol"] = {"1149612882", "1150842221"},
            ["Pirate"] = {"750781874", "750782770"},
            ["Very Long"] = {"18307781743", "18307781743"},
            ["Popstar"] = {"1212900985", "1150842221"},
            ["Princess"] = {"941003647", "941013098"},
            ["Robot"] = {"616088211", "616089559"},
            ["Sneaky"] = {"1132473842", "1132477671"},
            ["Sports (Adidas)"] = {"18537376492", "18537371272"},
            ["Soldier"] = {"3972151362", "3972151362"},
            ["Stylish"] = {"616136790", "616138447"},
            ["Superhero"] = {"10921288909", "10921290167"},
            ["Toy"] = {"782841498", "782845736"},
            ["Udzal"] = {"3303162274", "3303162549"},
            ["Vampire"] = {"1083445855", "1083450166"},
            ["Werewolf"] = {"1083195517", "1083214717"},
            ["Wicked (Popular)"] = {"118832222982049", "76049494037641"},
            ["No Boundaries (Walmart)"] = {"18747067405", "18747063918"},
            ["Zombie"] = {"616158929", "616160636"},
            ["Wicked \"Dancing Through Life\""] = {"92849173543269", "132238900951109"},
            ["Unboxed By Amazon"] = {"98281136301627", "138183121662404"},
            ["Glow Motion"] = {"137764781910579", "96439737641086"},
            ["Adidas Aura"] = {"110211186840347", "110211186840347"}
        },
        ["Walk"] = {
            ["Patrol"] = "1151231493",
            ["Adidas Community"] = "122150855457006",
            ["Levitation"] = "616013216",
            ["Catwalk Glam"] = "109168724482748",
            ["Knight"] = "10921127095",
            ["Pirate"] = "750785693",
            ["Bold"] = "16738340646",
            ["Sports (Adidas)"] = "18537392113",
            ["Zombie"] = "616168032",
            ["Astronaut"] = "891667138",
            ["Cartoony"] = "742640026",
            ["Ninja"] = "656121766",
            ["Confident"] = "1070017263",
            ["Wicked \"Dancing Through Life\""] = "73718308412641",
            ["Unboxed By Amazon"] = "90478085024465",
            ["Ghost"] = "616013216",
            ["No Boundaries (Walmart)"] = "18747074203",
            ["Werewolf"] = "1083178339",
            ["Wicked (Popular)"] = "92072849924640",
            ["Vampire"] = "1083473930",
            ["Popstar"] = "1212980338",
            ["Mage"] = "707897309",
            ["NFL"] = "110358958299415",
            ["Bubbly"] = "910034870",
            ["OldSchool"] = "10921244891",
            ["Elder"] = "10921111375",
            ["Stylish"] = "616146177",
            ["Robot"] = "616095330",
            ["Sneaky"] = "1132510133",
            ["Superhero"] = "10921298616",
            ["Udzal"] = "3303162967",
            ["Toy"] = "782843345",
            ["Princess"] = "941028902",
            ["Cowboy"] = "1014421541",
            ["Glow Motion"] = "85809016093530",
            ["Adidas Aura"] = "83842218823011"
        },
        ["Run"] = {
            ["Robot"] = "10921250460",
            ["Patrol"] = "1150967949",
            ["Adidas Community"] = "82598234841035",
            ["Heavy Run (Udzal / Borock)"] = "3236836670",
            ["Catwalk Glam"] = "81024476153754",
            ["Knight"] = "10921121197",
            ["Pirate"] = "750783738",
            ["Bold"] = "16738337225",
            ["Sports (Adidas)"] = "18537384940",
            ["Zombie"] = "616163682",
            ["Astronaut"] = "10921039308",
            ["Cartoony"] = "10921076136",
            ["Ninja"] = "656118852",
            ["(UGC) Dog"] = "130072963359721",
            ["Wicked \"Dancing Through Life\""] = "135515454877967",
            ["Unboxed By Amazon"] = "134824450619865",
            ["Sneaky"] = "1132494274",
            ["Popstar"] = "1212980348",
            ["Wicked (Popular)"] = "72301599441680",
            ["[UGC] chibi"] = "85887415033585",
            ["Mage"] = "10921148209",
            ["Ghost"] = "616013216",
            ["Confident"] = "1070001516",
            ["No Boundaries (Walmart)"] = "18747070484",
            ["Elder"] = "10921104374",
            ["Werewolf"] = "10921336997",
            ["Stylish"] = "10921276116",
            ["NFL"] = "117333533048078",
            ["MrToilet"] = "4417979645",
            ["Levitation"] = "616010382",
            ["OldSchool"] = "10921240218",
            ["Vampire"] = "10921320299",
            ["Bubbly"] = "10921057244",
            ["Superhero"] = "10921291831",
            ["Toy"] = "10921306285",
            ["Princess"] = "941015281",
            ["Cowboy"] = "1014401683",
            ["Glow Motion"] = "101925097435036",
            ["Adidas Aura"] = "118320322718866"
        },
        ["Jump"] = {
            ["Robot"] = "616090535",
            ["Patrol"] = "1148811837",
            ["Adidas Community"] = "75290611992385",
            ["Levitation"] = "616008936",
            ["Catwalk Glam"] = "116936326516985",
            ["Knight"] = "910016857",
            ["Pirate"] = "750782230",
            ["Bold"] = "16738336650",
            ["Sports (Adidas)"] = "18537380791",
            ["Zombie"] = "616161997",
            ["Astronaut"] = "891627522",
            ["Cartoony"] = "742637942",
            ["Ninja"] = "656117878",
            ["Confident"] = "1069984524",
            ["Wicked \"Dancing Through Life\""] = "78508480717326",
            ["Unboxed By Amazon"] = "121454505477205",
            ["Ghost"] = "616008936",
            ["No Boundaries (Walmart)"] = "18747069148",
            ["Werewolf"] = "1083218792",
            ["Cowboy"] = "1014394726",
            ["Popstar"] = "1212954642",
            ["Mage"] = "10921149743",
            ["Sneaky"] = "1132489853",
            ["Superhero"] = "10921294559",
            ["Elder"] = "10921107367",
            ["NFL"] = "119846112151352",
            ["OldSchool"] = "10921242013",
            ["Stylish"] = "616139451",
            ["Bubbly"] = "910016857",
            ["Vampire"] = "1083455352",
            ["Wicked (Popular)"] = "104325245285198",
            ["Toy"] = "10921308158",
            ["Princess"] = "941008832",
            ["Glow Motion"] = "74159004634379",
            ["Adidas Aura"] = "109996626521204"
        },
        ["Fall"] = {
            ["Robot"] = "616087089",
            ["Patrol"] = "1148863382",
            ["Adidas Community"] = "98600215928904",
            ["Levitation"] = "616005863",
            ["Catwalk Glam"] = "92294537340807",
            ["Knight"] = "10921122579",
            ["Pirate"] = "750780242",
            ["Bold"] = "16738333171",
            ["Sports (Adidas)"] = "18537367238",
            ["Zombie"] = "616157476",
            ["Astronaut"] = "891617961",
            ["Cartoony"] = "742637151",
            ["Ninja"] = "656115606",
            ["Confident"] = "1069973677",
            ["Wicked \"Dancing Through Life\""] = "78147885297412",
            ["Unboxed By Amazon"] = "94788218468396",
            ["No Boundaries (Walmart)"] = "18747062535",
            ["Werewolf"] = "1083189019",
            ["Mage"] = "707829716",
            ["Wicked (Popular)"] = "121152442762481",
            ["Popstar"] = "1212900995",
            ["NFL"] = "129773241321032",
            ["OldSchool"] = "10921241244",
            ["Sneaky"] = "1132469004",
            ["Elder"] = "10921105765",
            ["Bubbly"] = "910001910",
            ["Stylish"] = "616134815",
            ["Vampire"] = "1083443587",
            ["Superhero"] = "10921293373",
            ["Toy"] = "782846423",
            ["Princess"] = "941000007",
            ["Cowboy"] = "1014384571",
            ["Glow Motion"] = "98070939608691",
            ["Adidas Aura"] = "95603166884636"
        },
        ["SwimIdle"] = {
            ["Sneaky"] = "1132506407",
            ["SuperHero"] = "10921297391",
            ["Adidas Community"] = "109346520324160",
            ["Levitation"] = "10921139478",
            ["Catwalk Glam"] = "98854111361360",
            ["Knight"] = "10921125935",
            ["Pirate"] = "750785176",
            ["Bold"] = "16738339817",
            ["Sports (Adidas)"] = "18537387180",
            ["Astronaut"] = "891663592",
            ["Cartoony"] = "10921079380",
            ["Wicked (Popular)"] = "113199415118199",
            ["Mage"] = "707894699",
            ["Wicked \"Dancing Through Life\""] = "129183123083281",
            ["Unboxed By Amazon"] = "129126268464847",
            ["CowBoy"] = "1014411816",
            ["No Boundaries (Walmart)"] = "18747071682",
            ["Werewolf"] = "10921341319",
            ["NFL"] = "79090109939093",
            ["OldSchool"] = "10921244018",
            ["Robot"] = "10921253767",
            ["Elder"] = "10921110146",
            ["Bubbly"] = "910030921",
            ["Patrol"] = "1151221899",
            ["Vampire"] = "10921325443",
            ["Popstar"] = "1212998578",
            ["Ninja"] = "656118341",
            ["Toy"] = "10921310341",
            ["Confident"] = "1070012133",
            ["Princess"] = "941025398",
            ["Stylish"] = "10921281964",
            ["Glow Motion"] = "112946194103503"
        },
        ["Swim"] = {
            ["Sneaky"] = "1132500520",
            ["Patrol"] = "1151204998",
            ["Adidas Community"] = "133308483266208",
            ["Levitation"] = "10921138209",
            ["Catwalk Glam"] = "134591743181628",
            ["Knight"] = "10921125160",
            ["Pirate"] = "750784579",
            ["Bold"] = "16738339158",
            ["Sports (Adidas)"] = "18537389531",
            ["Zombie"] = "616165109",
            ["Astronaut"] = "891663592",
            ["Cartoony"] = "10921079380",
            ["Wicked (Popular)"] = "99384245425157",
            ["Mage"] = "707876443",
            ["PopStar"] = "1212998578",
            ["Unboxed By Amazon"] = "105962919001086",
            ["CowBoy"] = "1014406523",
            ["No Boundaries (Walmart)"] = "18747073181",
            ["Werewolf"] = "10921340419",
            ["NFL"] = "132697394189921",
            ["OldSchool"] = "10921243048",
            ["Wicked \"Dancing Through Life\""] = "110657013921774",
            ["Elder"] = "10921108971",
            ["Bubbly"] = "910028158",
            ["Robot"] = "10921253142",
            ["Vampire"] = "10921324408",
            ["Stylish"] = "10921281000",
            ["Toy"] = "10921309319",
            ["SuperHero"] = "10921295495",
            ["Princess"] = "941018893",
            ["Confident"] = "1070009914",
            ["Glow Motion"] = "83003487432457"
        },
        ["Climb"] = {
            ["Robot"] = "616086039",
            ["Patrol"] = "1148811837",
            ["Adidas Community"] = "88763136693023",
            ["Levitation"] = "10921132092",
            ["Catwalk Glam"] = "119377220967554",
            ["Knight"] = "10921125160",
            ["Bold"] = "16738332169",
            ["Sports (Adidas)"] = "18537363391",
            ["Zombie"] = "616156119",
            ["Astronaut"] = "10921032124",
            ["Cartoony"] = "742636889",
            ["Ninja"] = "656114359",
            ["Confident"] = "1069946257",
            ["Wicked \"Dancing Through Life\""] = "129447497744818",
            ["Unboxed By Amazon"] = "121145883950231",
            ["Ghost"] = "616003713",
            ["CowBoy"] = "1014380606",
            ["No Boundaries (Walmart)"] = "18747060903",
            ["Mage"] = "707826056",
            ["Popstar"] = "1213044953",
            ["NFL"] = "134630013742019",
            ["OldSchool"] = "10921229866",
            ["Sneaky"] = "1132461372",
            ["Elder"] = "845392038",
            ["Stylish"] = "10921271391",
            ["SuperHero"] = "10921286911",
            ["WereWolf"] = "10921329322",
            ["Vampire"] = "1083439238",
            ["Toy"] = "10921300839",
            ["Wicked (Popular)"] = "131326830509784",
            ["Princess"] = "940996062",
            ["Glow Motion"] = "108236155509584",
            ["Adidas Aura"] = "97824616490448"
        }
    }

    -- Always use OriginalAnimations and overwrite cache so list stays up to date
    pcall(function()
        writefile("GreyLikesToSmellUrFeet.json", HttpService:JSONEncode(OriginalAnimations))
    end)
    Animations = OriginalAnimations
    
    animationsLoaded = true
    return Animations
end

-- BUTTON POOL MANAGEMENT
local function createButtonPool()
    for i = 1, visibleButtonCount do
        local button = Instance.new("TextButton")
        button.Name = "PoolButton_" .. i
        button.Font = Enum.Font.SourceSansBold
        button.TextScaled = true
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Position = UDim2.new(0, 0, 0, (i-1) * 40)
        button.BackgroundTransparency = 0
        button.BorderSizePixel = 0
        button.Visible = false

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button

        button.Parent = scrollFrame
        table.insert(buttonPool, button)
    end
end

createButtonPool()

-- VIRTUALIZED SCROLLING
local allAnimationData = {}
local fullSetData = {}     -- Only entries that exist in 4+ anim types
local filteredAnimationData = {}

local function populateAnimationData()
    local typeOrder = {"Idle", "Walk", "Run", "Jump", "Fall", "Swim", "SwimIdle", "Climb"}
    
    -- Build full allAnimationData list
    for _, animType in ipairs(typeOrder) do
        local anims = Animations[animType]
        if anims then
            for name, ids in pairs(anims) do
                table.insert(allAnimationData, {
                    name = name,
                    type = animType,
                    ids = ids,
                    displayText = name .. " - " .. animType
                })
            end
        end
    end
    
    -- Build Full Set list: names that appear in 4+ slots
    -- Step 1: count how many slots each name appears in (case-insensitive key)
    local nameCount = {}
    local nameSlots = {} -- name -> {type -> ids}
    for _, animType in ipairs(typeOrder) do
        local anims = Animations[animType]
        if anims then
            for name, ids in pairs(anims) do
                local key = name:lower()
                nameCount[key] = (nameCount[key] or 0) + 1
                if not nameSlots[key] then
                    nameSlots[key] = { displayName = name }
                end
                nameSlots[key][animType] = ids
            end
        end
    end
    
    -- Step 2: collect names with 4+ slots as Full Set entries
    local seen = {}
    for key, count in pairs(nameCount) do
        if count >= 4 and not seen[key] then
            seen[key] = true
            local slots = nameSlots[key]
            table.insert(fullSetData, {
                name = slots.displayName,
                isFullSet = true,
                slots = slots,
                displayText = "⚡ " .. slots.displayName .. " (Full Set)"
            })
        end
    end
    
    -- Sort Full Set alphabetically
    table.sort(fullSetData, function(a, b) return a.name < b.name end)
    
    filteredAnimationData = allAnimationData
end

-- FIXED: Button callback management
local function updateVisibleButtons()
    local searchText = searchBar.Text:lower()
    local sourceData = isFullSetMode and fullSetData or allAnimationData
    
    -- Filter data if needed
    if searchText ~= "" then
        filteredAnimationData = {}
        for _, data in ipairs(sourceData) do
            if data.displayText:lower():find(searchText) then
                table.insert(filteredAnimationData, data)
            end
        end
    else
        filteredAnimationData = sourceData
    end
    
    -- Calculate visible range
    local scrollPosition = scrollFrame.CanvasPosition.Y
    local startIndex = math.floor(scrollPosition / 40) + 1
    local endIndex = math.min(startIndex + visibleButtonCount - 1, #filteredAnimationData)
    
    -- Clear existing connections
    for i, connection in ipairs(buttonConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    buttonConnections = {}
    
    -- Update button pool
    for i, button in ipairs(buttonPool) do
        local dataIndex = startIndex + i - 1
        
        if dataIndex <= endIndex and dataIndex <= #filteredAnimationData then
            local data = filteredAnimationData[dataIndex]
            button.Text = data.displayText
            button.Position = UDim2.new(0, 0, 0, (dataIndex-1) * 40)
            button.Visible = true
            
            -- Store the new connection
            buttonConnections[i] = button.MouseButton1Click:Connect(function()
                pcall(function()
                    if data.isFullSet then
                        -- Apply all available slots for this Full Set entry
                        local typeOrder = {"Idle", "Walk", "Run", "Jump", "Fall", "Swim", "SwimIdle", "Climb"}
                        for _, animType in ipairs(typeOrder) do
                            if data.slots[animType] then
                                setAnimation(animType, data.slots[animType])
                            end
                        end
                        Notify("Full Set", data.name .. " applied to all slots!", 2)
                    else
                        setAnimation(data.type, data.ids)
                    end
                end)
            end)
        else
            button.Visible = false
        end
    end
    
    -- Update canvas size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #filteredAnimationData * 40)
end

-- DEBOUNCED SEARCH
local searchDebounce
searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    if searchDebounce then
        searchDebounce:Disconnect()
    end
    
    searchDebounce = task.delay(0.3, function()
        updateVisibleButtons()
        searchDebounce = nil
    end)
end)

-- LAZY LOAD INITIALIZATION
local function initializeGUI()
    loadAnimations()
    populateAnimationData()
    updateVisibleButtons()
    
    -- Load in background to prevent lag
    task.spawn(function()
        -- Pre-load a few more animations if needed
        for i = 1, math.min(50, #allAnimationData) do
            task.wait()
        end
    end)
end

-- Initialize after a short delay to prevent initial lag
task.delay(0.5, initializeGUI)

-- Furina icon lives in its OWN ScreenGui — completely independent of the main frame
-- This is the only reliable way to get UICorner working without ClipsDescendants interference
local furinaGui = Instance.new("ScreenGui")
furinaGui.Name = "FurinaIconGui"
furinaGui.ResetOnSpawn = false
furinaGui.Parent = core

local FLabel = Instance.new("ImageButton")
FLabel.Name = "FLabel"
FLabel.Image = "rbxassetid://129041843013567"
FLabel.ScaleType = Enum.ScaleType.Crop
FLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
FLabel.BackgroundTransparency = 0
FLabel.BorderSizePixel = 0
FLabel.Visible = false
FLabel.Parent = furinaGui

local FLabelCorner = Instance.new("UICorner")
FLabelCorner.CornerRadius = UDim.new(0.15, 0)
FLabelCorner.Parent = FLabel

-- UPDATED SIZES FOR TALLER WINDOW
local normalSize = getScaledSize(0.3, 0.6) -- TALLER: 60% height
local normalPosition = UDim2.new(0.5, -normalSize.X.Offset / 2, 0.5, -normalSize.Y.Offset / 2)
local smallerSize = getScaledSize(0.055, 0.098) -- Even smaller icon
local smallerPosition = UDim2.new(1, -smallerSize.X.Offset - 10, 0, 10) -- Top-right corner
-- FLabel uses same position/size but applied to its own element
local furinaIconSize = smallerSize
local furinaIconPos = smallerPosition
local isSmall = false
local clickCount = 0

local function handleDoubleClick()
    if isSmall then
        -- Expand back to full panel
        frame.Size = normalSize
        frame.Position = normalPosition
        frame.BackgroundTransparency = 0.2
        frame.Visible = true
        UICorner.CornerRadius = UDim.new(0, 12)
        scrollFrame.Visible = true
        searchBar.Visible = true
        fullSetBtn.Visible = true
        resetBtn.Visible = true
        FLabel.Visible = false
    else
        -- Minimize: hide main frame, show Furina icon in its own GUI
        frame.Visible = false
        FLabel.Size = furinaIconSize
        FLabel.Position = furinaIconPos
        FLabel.Visible = true
    end
    isSmall = not isSmall
end

frame.MouseButton1Click:Connect(function()
    clickCount += 1
    if clickCount == 1 then
        task.delay(0.45, function()
            clickCount = 0
        end)
    elseif clickCount == 2 then
        handleDoubleClick()
        clickCount = 0
    end
end)

scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    updateVisibleButtons()
end)

-- Furina icon: drag + double-click to reopen
local furinaClickCount = 0
local furinaHolding = false
local furinaStartPos = nil
local furinaDragging = false
local furinaDragOffset = Vector2.new(0, 0)

FLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        furinaHolding = true
        furinaDragging = false
        furinaStartPos = Vector2.new(input.Position.X, input.Position.Y)
        local iconPos = FLabel.AbsolutePosition
        furinaDragOffset = Vector2.new(input.Position.X - iconPos.X, input.Position.Y - iconPos.Y)
    end
end)

FLabel.InputChanged:Connect(function(input)
    if furinaHolding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local dx = math.abs(input.Position.X - furinaStartPos.X)
        local dy = math.abs(input.Position.Y - furinaStartPos.Y)
        if dx > 5 or dy > 5 then
            furinaDragging = true
        end
        if furinaDragging then
            local vp = camera.ViewportSize
            local newX = input.Position.X - furinaDragOffset.X
            local newY = input.Position.Y - furinaDragOffset.Y
            newX = math.clamp(newX, 0, vp.X - FLabel.AbsoluteSize.X)
            newY = math.clamp(newY, 0, vp.Y - FLabel.AbsoluteSize.Y)
            FLabel.Position = UDim2.new(0, newX, 0, newY)
        end
    end
end)

FLabel.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not furinaDragging then
            furinaClickCount += 1
            if furinaClickCount == 1 then
                task.delay(0.45, function()
                    furinaClickCount = 0
                end)
            elseif furinaClickCount >= 2 then
                furinaClickCount = 0
                if isSmall then
                    handleDoubleClick()
                end
            end
        end
        furinaHolding = false
        furinaDragging = false
    end
end)

-- FULL SET BUTTON TOGGLE LOGIC
fullSetBtn.MouseButton1Click:Connect(function()
    isFullSetMode = not isFullSetMode
    if isFullSetMode then
        fullSetBtn.Text = "⚡ Full Set: ON"
        fullSetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 160)
        fullSetBtn.TextColor3 = Color3.fromRGB(255, 255, 100)
    else
        fullSetBtn.Text = "⚡ Full Set: OFF"
        fullSetBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
        fullSetBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    scrollFrame.CanvasPosition = Vector2.new(0, 0)
    updateVisibleButtons()
end)

-- RESET TO DEFAULT ANIMATIONS
resetBtn.MouseButton1Click:Connect(function()
    local player = Players.LocalPlayer
    local char = player.Character
    if not char then
        Notify("Reset", "No character found!", 2)
        return
    end
    local animate = char:FindFirstChild("Animate")
    if not animate then
        Notify("Reset", "Animate script not found!", 2)
        return
    end

    pcall(function()
        StopAnim()
        task.wait(0.05)

        if not defaultAnimIds.Walk then
            Notify("Reset", "Defaults were not captured!", 2)
            return
        end
        animate.idle.Animation1.AnimationId  = defaultAnimIds.Idle[1]
        animate.idle.Animation2.AnimationId  = defaultAnimIds.Idle[2]
        animate.walk.WalkAnim.AnimationId    = defaultAnimIds.Walk
        animate.run.RunAnim.AnimationId      = defaultAnimIds.Run
        animate.jump.JumpAnim.AnimationId    = defaultAnimIds.Jump
        animate.fall.FallAnim.AnimationId    = defaultAnimIds.Fall
        animate.climb.ClimbAnim.AnimationId  = defaultAnimIds.Climb
        if animate:FindFirstChild("swim") and defaultAnimIds.Swim then
            animate.swim.Swim.AnimationId     = defaultAnimIds.Swim
        end
        if animate:FindFirstChild("swimidle") and defaultAnimIds.SwimIdle then
            animate.swimidle.SwimIdle.AnimationId = defaultAnimIds.SwimIdle
        end

        -- Clear saved animations so they don't re-apply on respawn
        lastAnimations = {}
        pcall(function()
            writefile("MeWhenUrMom.json", "{}")
        end)

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.new(0,0,0)) end
    end)

    Notify("Reset", "Animations reset to Roblox default!", 2)
end)

local lastAnimations = {}

-- Load saved animations immediately and cache them
local function loadSavedAnimationsToCache()
    if isfile("MeWhenUrMom.json") then
        local success, data = pcall(function()
            return readfile("MeWhenUrMom.json")
        end)
        if success then
            local loadedData = HttpService:JSONDecode(data)
            -- Deep copy to cache
            for animType, animId in pairs(loadedData) do
                lastAnimations[animType] = animId
            end
            return true
        end
    end
    return false
end

-- Load animations to cache on script start
loadSavedAnimationsToCache()

-- Improved animation handling
local function StopAnim()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    if Hum then
        for _, track in ipairs(Hum:GetPlayingAnimationTracks()) do
            if track then
                track:Stop(0.1) -- Smooth stop
            end
        end
    end
end

-- Improved reset functions
local function ResetIdle()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    if not Hum then return end
    
    for _, track in ipairs(Hum:GetPlayingAnimationTracks()) do
        if track and (track.Name == "idle" or track.Name == "IdleAnimation") then
            track:Stop(0.1)
        end
    end
end

local function ResetWalk()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    if not Hum then return end
    
    for _, track in ipairs(Hum:GetPlayingAnimationTracks()) do
        if track and track.Name == "walk" then
            track:Stop(0.1)
        end
    end
end

local function ResetRun()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    if not Hum then return end
    
    for _, track in ipairs(Hum:GetPlayingAnimationTracks()) do
        if track and track.Name == "run" then
            track:Stop(0.1)
        end
    end
end

local function ResetJump()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    if not Hum then return end
    
    for _, track in ipairs(Hum:GetPlayingAnimationTracks()) do
        if track and track.Name == "jump" then
            track:Stop(0.1)
        end
    end
end

local function ResetFall()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    if not Hum then return end
    
    for _, track in ipairs(Hum:GetPlayingAnimationTracks()) do
        if track and track.Name == "fall" then
            track:Stop(0.1)
        end
    end
end

local function ResetSwim()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    if not Hum then return end
    
    for _, track in ipairs(Hum:GetPlayingAnimationTracks()) do
        if track and track.Name == "swim" then
            track:Stop(0.1)
        end
    end
end

local function ResetSwimIdle()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    if not Hum then return end
    
    for _, track in ipairs(Hum:GetPlayingAnimationTracks()) do
        if track and track.Name == "swimidle" then
            track:Stop(0.1)
        end
    end
end

local function ResetClimb()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    if not Hum then return end
    
    for _, track in ipairs(Hum:GetPlayingAnimationTracks()) do
        if track and track.Name == "climb" then
            track:Stop(0.1)
        end
    end
end

local function saveLastAnimations()
    local data = HttpService:JSONEncode(lastAnimations)
    pcall(function() 
        writefile("MeWhenUrMom.json", data) 
    end)
end

-- BATCHED ANIMATION SYSTEM
local pendingAnimations = {}
local animationApplyDebounce

local function applyPendingAnimations()
    if animationApplyDebounce then return end
    
    animationApplyDebounce = true
    task.delay(0.1, function()
        local player = Players.LocalPlayer
        if not player.Character then 
            animationApplyDebounce = false
            return
        end
        
        local Char = player.Character
        local Animate = Char:FindFirstChild("Animate")
        if not Animate then 
            animationApplyDebounce = false
            return
        end

        pcall(function()
            StopAnim()
            task.wait(0.05)
            
            for animType, animId in pairs(pendingAnimations) do
                lastAnimations[animType] = animId
                
                if animType == "Idle" then
                    ResetIdle()
                    Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=" .. animId[1]
                    Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=" .. animId[2]
                elseif animType == "Walk" then
                    ResetWalk()
                    Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=" .. animId
                elseif animType == "Run" then
                    ResetRun()
                    Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=" .. animId
                elseif animType == "Jump" then
                    ResetJump()
                    Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=" .. animId
                elseif animType == "Fall" then
                    ResetFall()
                    Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=" .. animId
                elseif animType == "Swim" and Animate:FindFirstChild("swim") then
                    ResetSwim()
                    Animate.swim.Swim.AnimationId = "http://www.roblox.com/asset/?id=" .. animId
                elseif animType == "SwimIdle" and Animate:FindFirstChild("swimidle") then
                    ResetSwimIdle()
                    Animate.swimidle.SwimIdle.AnimationId = "http://www.roblox.com/asset/?id=" .. animId
                elseif animType == "Climb" then
                    ResetClimb()
                    Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=" .. animId
                end
            end
            
            pendingAnimations = {}
            saveLastAnimations()
            
            local humanoid = Char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:Move(Vector3.new(0, 0, 0))
            end
        end)
        
        animationApplyDebounce = false
    end)
end

-- Improved setAnimation function
function setAnimation(animationType, animationId)
    if type(animationId) ~= "table" and type(animationId) ~= "string" then return end
    
    pendingAnimations[animationType] = animationId
    applyPendingAnimations()
end

-- Apply animations on character load
local function applyCachedAnimations(character)
    local hum = character:WaitForChild("Humanoid")
    local animate = character:WaitForChild("Animate", 5)
    if not animate then return end
    
    task.wait(0.5) -- Wait for character to fully initialize
    
    -- Apply cached animations with small delays between each
    local applyOrder = {"Idle", "Walk", "Run", "Jump", "Fall", "Climb", "Swim", "SwimIdle"}
    
    for _, animType in ipairs(applyOrder) do
        if lastAnimations[animType] then
            task.wait(0.1) -- Small delay to prevent race conditions
            setAnimation(animType, lastAnimations[animType])
        end
    end
end

-- OPTIMIZED CHARACTER EVENT HANDLING
local characterConnection
characterConnection = Players.LocalPlayer.CharacterAdded:Connect(function(character)
    -- Disconnect old connection to prevent multiple handlers
    if characterConnection then
        characterConnection:Disconnect()
        characterConnection = nil
    end
    
    -- Apply animations with retry logic
    local retryCount = 0
    local maxRetries = 3
    
    local function tryApplyAnimations()
        retryCount = retryCount + 1
        
        if retryCount > maxRetries then
            return
        end
        
        local success, err = pcall(function()
            applyCachedAnimations(character)
        end)
        
        if not success and retryCount <= maxRetries then
            task.wait(1) -- Wait before retry
            tryApplyAnimations()
        end
    end
    
    tryApplyAnimations()
    
    -- Reconnect for future character respawns
    characterConnection = Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.1) -- Small delay
        local newRetryCount = 0
        local function retryNewChar()
            newRetryCount = newRetryCount + 1
            if newRetryCount <= maxRetries then
                local success = pcall(function()
                    applyCachedAnimations(newChar)
                end)
                if not success and newRetryCount < maxRetries then
                    task.wait(1)
                    retryNewChar()
                end
            end
        end
        retryNewChar()
    end)
end)

-- Apply animations to current character if exists
if Players.LocalPlayer.Character then
    task.wait(1) -- Wait for everything to load
    applyCachedAnimations(Players.LocalPlayer.Character)
end

local lt = os.clock() - st
Notify("Optimized Load", string.format("in %.2f seconds.", lt), 3)

end)
