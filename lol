pcall(function()

local lp=game.Players.LocalPlayer
if not lp.Character or lp.Character:WaitForChild("Humanoid").RigType~=Enum.HumanoidRigType.R15 then
    game.StarterGui:SetCore("SendNotification",{Title="Error",Text="R15 required.",Duration=5})
    return
end

local st=os.clock()
local TS=game:GetService("TweenService")
local HS=game:GetService("HttpService")
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local cam=workspace.CurrentCamera
cloneref=cloneref or function(o) return o end
local root=cloneref(game.CoreGui)

local THEMES={
    {name="Warm",bg=Color3.fromRGB(22,21,20),panel=Color3.fromRGB(30,28,26),raised=Color3.fromRGB(40,37,34),
     hover=Color3.fromRGB(52,48,44),active=Color3.fromRGB(62,44,40),border=Color3.fromRGB(60,55,50),
     accent=Color3.fromRGB(188,120,90),text=Color3.fromRGB(220,210,195),textDim=Color3.fromRGB(110,100,90)},
    {name="Crimson",bg=Color3.fromRGB(14,10,10),panel=Color3.fromRGB(22,14,14),raised=Color3.fromRGB(34,20,20),
     hover=Color3.fromRGB(48,26,26),active=Color3.fromRGB(58,22,22),border=Color3.fromRGB(65,32,32),
     accent=Color3.fromRGB(180,60,60),text=Color3.fromRGB(220,200,200),textDim=Color3.fromRGB(110,75,75)},
}
local themeIdx=1
local P=THEMES[themeIdx]

local function corner(o,r) local c=Instance.new("UICorner",o) c.CornerRadius=UDim.new(0,r or 6) end
local function mkstroke(o,col,th,tr) local s=Instance.new("UIStroke",o) s.Color=col s.Thickness=th or 1 s.Transparency=tr or 0.6 end
local function vp() return cam.ViewportSize end
local isTouch=UIS.TouchEnabled

if root:FindFirstChild("_av6") then return end
local g=Instance.new("ScreenGui") g.Name="_av6" g.ResetOnSpawn=false g.Parent=root
for _,n in ipairs({"_avMain","_avIcon"}) do local o=root:FindFirstChild(n) if o then o:Destroy() end end

-- notifications
local notifs={}
local function Notify(title,body,dur)
    coroutine.wrap(function()
        local W=math.floor(vp().X*0.19) local H=math.floor(vp().Y*0.075)
        local sg=Instance.new("ScreenGui") sg.Parent=root
        local f=Instance.new("Frame",sg)
        f.Size=UDim2.new(0,W,0,H) f.BackgroundColor3=P.panel f.BorderSizePixel=0
        corner(f,6) mkstroke(f,P.border,1,0.4)
        local bar=Instance.new("Frame",f) bar.Size=UDim2.new(0,3,1,0) bar.BackgroundColor3=P.accent bar.BorderSizePixel=0 corner(bar,3)
        local tl=Instance.new("TextLabel",f) tl.Size=UDim2.new(1,-12,0.45,0) tl.Position=UDim2.new(0,10,0,5)
        tl.BackgroundTransparency=1 tl.Font=Enum.Font.GothamBold tl.Text=title tl.TextColor3=P.accent tl.TextScaled=true tl.TextXAlignment=Enum.TextXAlignment.Left
        local bl=Instance.new("TextLabel",f) bl.Size=UDim2.new(1,-12,0.5,0) bl.Position=UDim2.new(0,10,0.47,0)
        bl.BackgroundTransparency=1 bl.Font=Enum.Font.Gotham bl.Text=body bl.TextColor3=P.textDim bl.TextScaled=true bl.TextXAlignment=Enum.TextXAlignment.Left
        local off=12
        for _,n in ipairs(notifs) do off=off+n.AbsoluteSize.Y+6 end
        f.Position=UDim2.new(1,6,0,off) table.insert(notifs,f)
        task.wait(0.05)
        f:TweenPosition(UDim2.new(1,-W-10,0,off),Enum.EasingDirection.Out,Enum.EasingStyle.Quint,0.3,true)
        task.wait(dur)
        f:TweenPosition(UDim2.new(1,6,0,off),Enum.EasingDirection.In,Enum.EasingStyle.Quint,0.28,true)
        task.wait(0.35) sg:Destroy()
        for i,n in ipairs(notifs) do if n==f then table.remove(notifs,i) break end end
        for i,n in ipairs(notifs) do n:TweenPosition(UDim2.new(1,-W-10,0,12+(n.AbsoluteSize.Y+6)*(i-1)),Enum.EasingDirection.Out,Enum.EasingStyle.Quint,0.28,true) end
    end)()
end

local PW=math.floor(vp().X*0.27)
local PH=math.floor(vp().Y*0.58)
local IW=math.floor(vp().X*0.04)
local IH=math.floor(vp().Y*0.072)
local PAD=8
local HH=math.floor(PH*0.09)
local SH=math.floor(PH*0.065)
local TH=math.floor(PH*0.058)
local TAGW=math.floor(PW*0.28)
local toggleY=HH+PAD+SH+5
local listY=toggleY+TH+6
local listH=PH-listY-PAD

local mainSG=Instance.new("ScreenGui") mainSG.Name="_avMain" mainSG.ResetOnSpawn=false mainSG.Parent=root

local shadow=Instance.new("Frame",mainSG)
shadow.Size=UDim2.new(0,PW,0,PH) shadow.BackgroundColor3=Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency=0.65 shadow.BorderSizePixel=0
shadow.Position=UDim2.new(0.5,-PW/2+4,0.5,-PH/2+5) corner(shadow,10)

local panel=Instance.new("Frame",mainSG)
panel.Name="Panel" panel.Size=UDim2.new(0,PW,0,PH)
panel.Position=UDim2.new(0.5,-PW/2,0.5,-PH/2)
panel.BackgroundColor3=P.panel panel.BorderSizePixel=0 panel.ClipsDescendants=true
corner(panel,8) local panelStroke=mkstroke(panel,P.border,1,0.5)

local header=Instance.new("Frame",panel)
header.Size=UDim2.new(1,0,0,HH) header.BackgroundColor3=P.bg header.BorderSizePixel=0

local rule=Instance.new("Frame",header)
rule.Size=UDim2.new(1,0,0,1) rule.Position=UDim2.new(0,0,1,-1)
rule.BackgroundColor3=P.border rule.BorderSizePixel=0

local titleLbl=Instance.new("TextLabel",header)
titleLbl.Size=UDim2.new(0.5,0,1,0) titleLbl.Position=UDim2.new(0,10,0,0)
titleLbl.BackgroundTransparency=1 titleLbl.Font=Enum.Font.Antique
titleLbl.Text="Animations" titleLbl.TextColor3=P.text
titleLbl.TextScaled=true titleLbl.TextXAlignment=Enum.TextXAlignment.Left

local themeBtn=Instance.new("TextButton",header)
themeBtn.Size=UDim2.new(0,math.floor(PW*0.22),0,math.floor(HH*0.55))
themeBtn.Position=UDim2.new(1,-math.floor(PW*0.31),0.5,-math.floor(HH*0.275))
themeBtn.BackgroundColor3=P.raised themeBtn.BorderSizePixel=0
themeBtn.Font=Enum.Font.Gotham themeBtn.Text=P.name
themeBtn.TextColor3=P.textDim themeBtn.TextScaled=true corner(themeBtn,4)

local minBtn=Instance.new("TextButton",header)
minBtn.Size=UDim2.new(0,24,0,math.floor(HH*0.55))
minBtn.Position=UDim2.new(1,-30,0.5,-math.floor(HH*0.275))
minBtn.BackgroundColor3=P.raised minBtn.BorderSizePixel=0
minBtn.Font=Enum.Font.GothamBold minBtn.Text="-"
minBtn.TextColor3=P.textDim minBtn.TextScaled=true corner(minBtn,4)

-- drag
local dragging,dStart,dOrigin=false,nil,nil
local function syncShadow() shadow.Position=UDim2.new(0,panel.Position.X.Offset+4,0,panel.Position.Y.Offset+5) end
header.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        dragging=true dStart=inp.Position dOrigin=panel.Position
        inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
    end
end)
UIS.InputChanged:Connect(function(inp)
    if not dragging then return end
    if inp.UserInputType~=Enum.UserInputType.MouseMovement and inp.UserInputType~=Enum.UserInputType.Touch then return end
    local d=inp.Position-dStart local v=vp()
    panel.Position=UDim2.new(0,math.clamp(dOrigin.X.Offset+d.X,0,v.X-PW),0,math.clamp(dOrigin.Y.Offset+d.Y,0,v.Y-PH))
    syncShadow()
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)

local searchBg=Instance.new("Frame",panel)
searchBg.Size=UDim2.new(1,-PAD*2,0,SH) searchBg.Position=UDim2.new(0,PAD,0,HH+PAD)
searchBg.BackgroundColor3=P.bg searchBg.BorderSizePixel=0
corner(searchBg,5) local searchStroke=mkstroke(searchBg,P.border,1,0.5)

local searchBox=Instance.new("TextBox",searchBg)
searchBox.Size=UDim2.new(1,-8,1,0) searchBox.Position=UDim2.new(0,4,0,0)
searchBox.BackgroundTransparency=1 searchBox.Font=Enum.Font.Gotham
searchBox.PlaceholderText="Search..." searchBox.PlaceholderColor3=P.textDim
searchBox.Text="" searchBox.TextColor3=P.text searchBox.TextScaled=true
searchBox.ClearTextOnFocus=false searchBox.BorderSizePixel=0

local fullBtn=Instance.new("TextButton",panel)
fullBtn.Size=UDim2.new(1,-PAD*2,0,TH) fullBtn.Position=UDim2.new(0,PAD,0,toggleY)
fullBtn.BackgroundColor3=P.raised fullBtn.BorderSizePixel=0
fullBtn.Font=Enum.Font.GothamBold fullBtn.Text="Full Set  OFF"
fullBtn.TextColor3=P.textDim fullBtn.TextScaled=true
corner(fullBtn,5) mkstroke(fullBtn,P.border,1,0.6)

local list=Instance.new("ScrollingFrame",panel)
list.Size=UDim2.new(1,-PAD*2,0,listH) list.Position=UDim2.new(0,PAD,0,listY)
list.BackgroundColor3=P.bg list.BorderSizePixel=0
list.ScrollBarThickness=3 list.ScrollBarImageColor3=P.accent
list.ScrollBarImageTransparency=0.3 list.ScrollingDirection=Enum.ScrollingDirection.Y
list.CanvasSize=UDim2.new(0,0,0,0) list.ElasticBehavior=Enum.ElasticBehavior.WhenScrollable
corner(list,5)

-- icon
local iconSG=Instance.new("ScreenGui") iconSG.Name="_avIcon" iconSG.ResetOnSpawn=false iconSG.Parent=root
local icon=Instance.new("ImageButton",iconSG)
icon.Image="rbxassetid://129041843013567" icon.ScaleType=Enum.ScaleType.Crop
icon.Size=UDim2.new(0,IW,0,IH) icon.Position=UDim2.new(1,-IW-10,0,10)
icon.BackgroundColor3=P.raised icon.BorderSizePixel=0 icon.Visible=false corner(icon,8)

local iHold,iDrag,iIS,iPS=false,false,Vector2.new(),Vector2.new()
icon.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        iHold=true iDrag=false
        iIS=Vector2.new(inp.Position.X,inp.Position.Y)
        iPS=Vector2.new(icon.AbsolutePosition.X,icon.AbsolutePosition.Y)
    end
end)
UIS.InputChanged:Connect(function(inp)
    if not iHold then return end
    if inp.UserInputType~=Enum.UserInputType.MouseMovement and inp.UserInputType~=Enum.UserInputType.Touch then return end
    local dx=inp.Position.X-iIS.X local dy=inp.Position.Y-iIS.Y
    if not iDrag and (math.abs(dx)>10 or math.abs(dy)>10) then iDrag=true end
    if iDrag then local v=vp()
        icon.Position=UDim2.new(0,math.clamp(iPS.X+dx,0,v.X-IW),0,math.clamp(iPS.Y+dy,0,v.Y-IH))
    end
end)

local isMin=false
local function minimize()
    isMin=true
    TS:Create(panel,TweenInfo.new(0.2),{Size=UDim2.new(0,PW,0,0),BackgroundTransparency=1}):Play()
    TS:Create(shadow,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
    task.delay(0.22,function() panel.Visible=false shadow.Visible=false icon.Visible=true end)
end
local function restore()
    isMin=false icon.Visible=false panel.Visible=true shadow.Visible=true
    panel.Size=UDim2.new(0,PW,0,0) panel.BackgroundTransparency=1
    TS:Create(panel,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,PW,0,PH),BackgroundTransparency=0}):Play()
    TS:Create(shadow,TweenInfo.new(0.3),{BackgroundTransparency=0.65}):Play()
end
minBtn.MouseButton1Click:Connect(minimize)
icon.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        if not iDrag and isMin then restore() end
        iHold=false iDrag=false
    end
end)
UIS.InputBegan:Connect(function(inp,gp)
    if gp then return end
    if inp.KeyCode==Enum.KeyCode.RightShift then if isMin then restore() else minimize() end end
end)

-- pool forward ref
local pool={}

local function applyTheme()
    P=THEMES[themeIdx]
    panel.BackgroundColor3=P.panel header.BackgroundColor3=P.bg rule.BackgroundColor3=P.border
    titleLbl.TextColor3=P.text
    themeBtn.BackgroundColor3=P.raised themeBtn.TextColor3=P.textDim themeBtn.Text=P.name
    minBtn.BackgroundColor3=P.raised minBtn.TextColor3=P.textDim
    searchBg.BackgroundColor3=P.bg
    local ss=searchBg:FindFirstChildOfClass("UIStroke") if ss then ss.Color=P.border end
    searchBox.TextColor3=P.text searchBox.PlaceholderColor3=P.textDim
    fullBtn.BackgroundColor3=P.raised fullBtn.TextColor3=P.textDim
    list.BackgroundColor3=P.bg list.ScrollBarImageColor3=P.accent
    icon.BackgroundColor3=P.raised
    local ps=panel:FindFirstChildOfClass("UIStroke") if ps then ps.Color=P.border end
    for _,r in ipairs(pool) do
        r.btn.BackgroundColor3=P.raised
        r.nl.TextColor3=P.textDim r.tl.TextColor3=P.textDim r.bar.BackgroundColor3=P.accent
    end
end
themeBtn.MouseButton1Click:Connect(function()
    themeIdx=themeIdx%#THEMES+1 applyTheme()
end)

-- database
local DB
local function loadDB()
    if DB then return end
    DB={
        Idle={
            ["Rthro"]={"10921259953","10921258489"},
            ["Astronaut"]={"891621366","891633237"},["Adidas Community"]={"122257458498464","102357151005774"},
            ["Bold"]={"16738333868","16738334710"},["Borock"]={"3293641938","3293642554"},
            ["Bubbly"]={"910004836","910009958"},["Cartoony"]={"742637544","742638445"},
            ["Confident"]={"1069977950","1069987858"},["Catwalk Glam"]={"133806214992291","94970088341563"},
            ["Cowboy"]={"1014390418","1014398616"},["Elder"]={"10921101664","10921102574"},
            ["Ghost"]={"616006778","616008087"},["Knight"]={"657595757","657568135"},
            ["Levitation"]={"616006778","616008087"},["Mage"]={"707742142","707855907"},
            ["MrToilet"]={"4417977954","4417978624"},["Ninja"]={"656117400","656118341"},
            ["NFL"]={"92080889861410","74451233229259"},["OldSchool"]={"10921230744","10921232093"},
            ["Patrol"]={"1149612882","1150842221"},["Pirate"]={"750781874","750782770"},
            ["Popstar"]={"1212900985","1150842221"},["Princess"]={"941003647","941013098"},
            ["Robot"]={"616088211","616089559"},["Sneaky"]={"1132473842","1132477671"},
            ["Sports (Adidas)"]={"18537376492","18537371272"},["Stylish"]={"616136790","616138447"},
            ["Superhero"]={"10921288909","10921290167"},["Toy"]={"782841498","782845736"},
            ["Udzal"]={"3303162274","3303162549"},["Vampire"]={"1083445855","1083450166"},
            ["Werewolf"]={"1083195517","1083214717"},["Wicked (Popular)"]={"118832222982049","76049494037641"},
            ["Wicked Dancing"]={"92849173543269","132238900951109"},["Zombie"]={"616158929","616160636"},
            ["Glow Motion"]={"137764781910579","96439737641086"},["Adidas Aura"]={"110211186840347","110211186840347"},
            ["No Boundaries"]={"18747067405","18747063918"},["Unboxed By Amazon"]={"98281136301627","138183121662404"},
        },
        Walk={
            ["Rthro"]="10921269718",["Patrol"]="1151231493",["Adidas Community"]="122150855457006",
            ["Levitation"]="616013216",["Catwalk Glam"]="109168724482748",["Knight"]="10921127095",
            ["Pirate"]="750785693",["Bold"]="16738340646",["Sports (Adidas)"]="18537392113",
            ["Zombie"]="616168032",["Astronaut"]="891667138",["Cartoony"]="742640026",
            ["Ninja"]="656121766",["Confident"]="1070017263",["Wicked Dancing"]="73718308412641",
            ["Unboxed By Amazon"]="90478085024465",["Ghost"]="616013216",["No Boundaries"]="18747074203",
            ["Werewolf"]="1083178339",["Wicked (Popular)"]="92072849924640",["Vampire"]="1083473930",
            ["Popstar"]="1212980338",["Mage"]="707897309",["NFL"]="110358958299415",
            ["Bubbly"]="910034870",["OldSchool"]="10921244891",["Elder"]="10921111375",
            ["Stylish"]="616146177",["Robot"]="616095330",["Sneaky"]="1132510133",
            ["Superhero"]="10921298616",["Udzal"]="3303162967",["Toy"]="782843345",
            ["Princess"]="941028902",["Cowboy"]="1014421541",["Glow Motion"]="85809016093530",
            ["Adidas Aura"]="83842218823011",
        },
        Run={
            ["Rthro"]="10921261968",["Robot"]="10921250460",["Patrol"]="1150967949",
            ["Adidas Community"]="82598234841035",["Heavy Run"]="3236836670",["Catwalk Glam"]="81024476153754",
            ["Knight"]="10921121197",["Pirate"]="750783738",["Bold"]="16738337225",
            ["Sports (Adidas)"]="18537384940",["Zombie"]="616163682",["Astronaut"]="10921039308",
            ["Cartoony"]="10921076136",["Ninja"]="656118852",["Wicked Dancing"]="135515454877967",
            ["Unboxed By Amazon"]="134824450619865",["Sneaky"]="1132494274",["Popstar"]="1212980348",
            ["Wicked (Popular)"]="72301599441680",["Mage"]="10921148209",["Confident"]="1070001516",
            ["No Boundaries"]="18747070484",["Elder"]="10921104374",["Werewolf"]="10921336997",
            ["Stylish"]="10921276116",["NFL"]="117333533048078",["Levitation"]="616010382",
            ["OldSchool"]="10921240218",["Vampire"]="10921320299",["Bubbly"]="10921057244",
            ["Superhero"]="10921291831",["Toy"]="10921306285",["Princess"]="941015281",
            ["Cowboy"]="1014401683",["Glow Motion"]="101925097435036",["Adidas Aura"]="118320322718866",
        },
        Jump={
            ["Rthro"]="10921263860",["Robot"]="616090535",["Patrol"]="1148811837",
            ["Adidas Community"]="75290611992385",["Levitation"]="616008936",["Catwalk Glam"]="116936326516985",
            ["Knight"]="910016857",["Pirate"]="750782230",["Bold"]="16738336650",
            ["Sports (Adidas)"]="18537380791",["Zombie"]="616161997",["Astronaut"]="891627522",
            ["Cartoony"]="742637942",["Ninja"]="656117878",["Confident"]="1069984524",
            ["Wicked Dancing"]="78508480717326",["Unboxed By Amazon"]="121454505477205",
            ["Ghost"]="616008936",["No Boundaries"]="18747069148",["Werewolf"]="1083218792",
            ["Cowboy"]="1014394726",["Popstar"]="1212954642",["Mage"]="10921149743",
            ["Sneaky"]="1132489853",["Superhero"]="10921294559",["Elder"]="10921107367",
            ["NFL"]="119846112151352",["OldSchool"]="10921242013",["Stylish"]="616139451",
            ["Bubbly"]="910016857",["Vampire"]="1083455352",["Wicked (Popular)"]="104325245285198",
            ["Toy"]="10921308158",["Princess"]="941008832",["Glow Motion"]="74159004634379",
            ["Adidas Aura"]="109996626521204",
        },
        Fall={
            ["Rthro"]="10921262864",["Robot"]="616087089",["Patrol"]="1148863382",
            ["Adidas Community"]="98600215928904",["Levitation"]="616005863",["Catwalk Glam"]="92294537340807",
            ["Knight"]="10921122579",["Pirate"]="750780242",["Bold"]="16738333171",
            ["Sports (Adidas)"]="18537367238",["Zombie"]="616157476",["Astronaut"]="891617961",
            ["Cartoony"]="742637151",["Ninja"]="656115606",["Confident"]="1069973677",
            ["Wicked Dancing"]="78147885297412",["Unboxed By Amazon"]="94788218468396",
            ["No Boundaries"]="18747062535",["Werewolf"]="1083189019",["Mage"]="707829716",
            ["Wicked (Popular)"]="121152442762481",["Popstar"]="1212900995",["NFL"]="129773241321032",
            ["OldSchool"]="10921241244",["Sneaky"]="1132469004",["Elder"]="10921105765",
            ["Bubbly"]="910001910",["Stylish"]="616134815",["Vampire"]="1083443587",
            ["Superhero"]="10921293373",["Toy"]="782846423",["Princess"]="941000007",
            ["Cowboy"]="1014384571",["Glow Motion"]="98070939608691",["Adidas Aura"]="95603166884636",
        },
        SwimIdle={
            ["Rthro"]="10921265698",["Sneaky"]="1132506407",["Superhero"]="10921297391",
            ["Adidas Community"]="109346520324160",["Levitation"]="10921139478",["Catwalk Glam"]="98854111361360",
            ["Knight"]="10921125935",["Pirate"]="750785176",["Bold"]="16738339817",
            ["Sports (Adidas)"]="18537387180",["Astronaut"]="891663592",["Cartoony"]="10921079380",
            ["Wicked (Popular)"]="113199415118199",["Mage"]="707894699",["Wicked Dancing"]="129183123083281",
            ["Unboxed By Amazon"]="129126268464847",["Cowboy"]="1014411816",["No Boundaries"]="18747071682",
            ["Werewolf"]="10921341319",["NFL"]="79090109939093",["OldSchool"]="10921244018",
            ["Robot"]="10921253767",["Elder"]="10921110146",["Bubbly"]="910030921",
            ["Patrol"]="1151221899",["Vampire"]="10921325443",["Popstar"]="1212998578",
            ["Ninja"]="656118341",["Toy"]="10921310341",["Confident"]="1070012133",
            ["Princess"]="941025398",["Stylish"]="10921281964",["Glow Motion"]="112946194103503",
        },
        Swim={
            ["Rthro"]="10921264784",["Sneaky"]="1132500520",["Patrol"]="1151204998",
            ["Adidas Community"]="133308483266208",["Levitation"]="10921138209",["Catwalk Glam"]="134591743181628",
            ["Knight"]="10921125160",["Pirate"]="750784579",["Bold"]="16738339158",
            ["Sports (Adidas)"]="18537389531",["Zombie"]="616165109",["Astronaut"]="891663592",
            ["Cartoony"]="10921079380",["Wicked (Popular)"]="99384245425157",["Mage"]="707876443",
            ["Popstar"]="1212998578",["Unboxed By Amazon"]="105962919001086",["Cowboy"]="1014406523",
            ["No Boundaries"]="18747073181",["Werewolf"]="10921340419",["NFL"]="132697394189921",
            ["OldSchool"]="10921243048",["Wicked Dancing"]="110657013921774",["Elder"]="10921108971",
            ["Bubbly"]="910028158",["Robot"]="10921253142",["Vampire"]="10921324408",
            ["Stylish"]="10921281000",["Toy"]="10921309319",["Superhero"]="10921295495",
            ["Princess"]="941018893",["Confident"]="1070009914",["Glow Motion"]="83003487432457",
        },
        Climb={
            ["Rthro"]="10921257536",["Robot"]="616086039",["Patrol"]="1148811837",
            ["Adidas Community"]="88763136693023",["Levitation"]="10921132092",["Catwalk Glam"]="119377220967554",
            ["Knight"]="10921125160",["Bold"]="16738332169",["Sports (Adidas)"]="18537363391",
            ["Zombie"]="616156119",["Astronaut"]="10921032124",["Cartoony"]="742636889",
            ["Ninja"]="656114359",["Confident"]="1069946257",["Wicked Dancing"]="129447497744818",
            ["Unboxed By Amazon"]="121145883950231",["Ghost"]="616003713",["Cowboy"]="1014380606",
            ["No Boundaries"]="18747060903",["Mage"]="707826056",["Popstar"]="1213044953",
            ["NFL"]="134630013742019",["OldSchool"]="10921229866",["Sneaky"]="1132461372",
            ["Elder"]="845392038",["Stylish"]="10921271391",["Superhero"]="10921286911",
            ["Werewolf"]="10921329322",["Vampire"]="1083439238",["Toy"]="10921300839",
            ["Wicked (Popular)"]="131326830509784",["Princess"]="940996062",
            ["Glow Motion"]="108236155509584",["Adidas Aura"]="97824616490448",
        }
    }
end

local ORDER={"Idle","Walk","Run","Jump","Fall","Swim","SwimIdle","Climb"}
local saved={}
pcall(function()
    if isfile and isfile("av_saves.json") then
        local ok,raw=pcall(readfile,"av_saves.json")
        if ok then pcall(function() for k,v in pairs(HS:JSONDecode(raw)) do saved[k]=v end end) end
    end
end)

local TNAME={Idle="idle",Walk="walk",Run="run",Jump="jump",Fall="fall",Swim="swim",SwimIdle="swimidle",Climb="climb"}
local function hotswap(animType,animId)
    local char=Players.LocalPlayer.Character
    local Anim=char and char:FindFirstChild("Animate")
    if not Anim then return end
    local pre="rbxassetid://"
    pcall(function()
        if animType=="Idle" then
            Anim.idle.Animation1.AnimationId=pre..animId[1]
            Anim.idle.Animation2.AnimationId=pre..animId[2]
        elseif animType=="Walk"     then Anim.walk.WalkAnim.AnimationId=pre..animId
        elseif animType=="Run"      then Anim.run.RunAnim.AnimationId=pre..animId
        elseif animType=="Jump"     then Anim.jump.JumpAnim.AnimationId=pre..animId
        elseif animType=="Fall"     then Anim.fall.FallAnim.AnimationId=pre..animId
        elseif animType=="Swim" and Anim:FindFirstChild("swim") then Anim.swim.Swim.AnimationId=pre..animId
        elseif animType=="SwimIdle" and Anim:FindFirstChild("swimidle") then Anim.swimidle.SwimIdle.AnimationId=pre..animId
        elseif animType=="Climb"    then Anim.climb.ClimbAnim.AnimationId=pre..animId
        end
    end)
    pcall(function()
        local hum=char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
        if not hum then return end
        local tn=TNAME[animType]
        for _,tr in ipairs(hum:GetPlayingAnimationTracks()) do
            if tr.Name==tn then tr:Stop(0) break end
        end
    end)
end

local function setAnim(t,id)
    if type(id)~="table" and type(id)~="string" then return end
    saved[t]=id hotswap(t,id)
    pcall(function() writefile("av_saves.json",HS:JSONEncode(saved)) end)
end

Players.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.7)
    local Anim=char:WaitForChild("Animate",5)
    if not Anim then return end
    task.wait(0.2)
    for _,t in ipairs(ORDER) do if saved[t] then task.wait(0.04) hotswap(t,saved[t]) end end
end)
if Players.LocalPlayer.Character then
    task.delay(1.2,function()
        for _,t in ipairs(ORDER) do if saved[t] then hotswap(t,saved[t]) end end
    end)
end

-- ── virtual list ─────────────────────────────────────────────────────────────
-- LAG FIXES:
-- 1. Pool stores cached child refs so no FindFirstChild per frame
-- 2. Hover connections stored per-row and only assigned ONCE at creation, not per updateList
-- 3. Scroll throttle: updateList only fires when scroll crosses a row boundary
-- 4. No TweenService calls at all in hot path (scroll/update)
-- 5. Filtered array reused, only rebuilt when search changes

local POOL=14
local RH=33
local RS=RH+3
local pConns={}     -- click connections only
local hConns={}     -- hover connections, assigned once, never reconnected
local allData,fullData,filtered={},{},{}
local activeKey=nil
local isFull=false
local lastScrollRow=-1  -- throttle: track last row index drawn

-- each pool entry stores refs to avoid FindFirstChild
-- pool[i] = {btn, nl, tl, bar}
local function makeRow(i)
    local btn=Instance.new("TextButton",list)
    btn.Name="R"..i btn.Size=UDim2.new(1,0,0,RH)
    btn.Position=UDim2.new(0,0,0,(i-1)*RS)
    btn.BackgroundColor3=P.raised btn.BorderSizePixel=0
    btn.Font=Enum.Font.Gotham btn.Text=""
    btn.TextScaled=true btn.ClipsDescendants=false
    btn.Visible=false btn.ZIndex=3
    corner(btn,5)

    local nl=Instance.new("TextLabel",btn)
    nl.Name="NL" nl.Size=UDim2.new(1,-TAGW,1,0) nl.Position=UDim2.new(0,8,0,0)
    nl.BackgroundTransparency=1 nl.Font=Enum.Font.Gotham nl.Text=""
    nl.TextColor3=P.textDim nl.TextScaled=true nl.TextXAlignment=Enum.TextXAlignment.Left
    nl.TextTruncate=Enum.TextTruncate.AtEnd nl.ZIndex=4

    local tl=Instance.new("TextLabel",btn)
    tl.Name="TL" tl.Size=UDim2.new(0,TAGW-8,1,0) tl.Position=UDim2.new(1,-TAGW,0,0)
    tl.BackgroundTransparency=1 tl.Font=Enum.Font.Gotham tl.Text=""
    tl.TextColor3=P.textDim tl.TextScaled=true tl.TextXAlignment=Enum.TextXAlignment.Right
    tl.ZIndex=4

    local bar=Instance.new("Frame",btn)
    bar.Name="Bar" bar.Size=UDim2.new(0,3,0.5,0) bar.Position=UDim2.new(0,0,0.25,0)
    bar.BackgroundColor3=P.accent bar.BorderSizePixel=0 bar.Visible=false bar.ZIndex=4
    corner(bar,2)

    local ref={btn=btn,nl=nl,tl=tl,bar=bar}
    pool[i]=ref

    -- hover assigned ONCE here, reads activeKey at call time (closure over ref)
    if not isTouch then
        hConns[i]=btn.MouseEnter:Connect(function()
            if activeKey~=ref._key then
                btn.BackgroundColor3=P.hover nl.TextColor3=P.text
            end
        end)
        btn.MouseLeave:Connect(function()
            if activeKey~=ref._key then
                btn.BackgroundColor3=P.raised nl.TextColor3=P.textDim
            end
        end)
    end
    return ref
end
for i=1,POOL do makeRow(i) end

local function populateData()
    allData={}
    for _,t in ipairs(ORDER) do
        local anims=DB[t]
        if anims then for name,ids in pairs(anims) do
            table.insert(allData,{name=name,type=t,ids=ids,key=name..t})
        end end
    end
    table.sort(allData,function(a,b) return a.name<b.name end)

    local cnt,slots={},{}
    for _,t in ipairs(ORDER) do
        if DB[t] then for name,ids in pairs(DB[t]) do
            local k=name:lower()
            cnt[k]=(cnt[k] or 0)+1
            if not slots[k] then slots[k]={dn=name} end
            slots[k][t]=ids
        end end
    end
    fullData={} local seen={}
    for k,n in pairs(cnt) do
        if n>=4 and not seen[k] then seen[k]=true
            local s=slots[k]
            table.insert(fullData,{name=s.dn,isFullSet=true,slots=s,type="SET",key=s.dn.."SET"})
        end
    end
    table.sort(fullData,function(a,b) return a.name<b.name end)
end

local filteredDirty=true
local lastQ=""

local function rebuildFiltered()
    local src=isFull and fullData or allData
    local q=searchBox.Text:lower()
    lastQ=q
    if q~="" then
        filtered={}
        for _,d in ipairs(src) do if d.name:lower():find(q,1,true) then table.insert(filtered,d) end end
    else filtered=src end
    filteredDirty=false
    lastScrollRow=-1  -- force redraw
end

local function renderRows()
    local sy=list.CanvasPosition.Y
    local s1=math.floor(sy/RS)+1
    if s1==lastScrollRow and not filteredDirty then return end  -- nothing changed
    lastScrollRow=s1
    local s2=math.min(s1+POOL-1,#filtered)

    for _,c in ipairs(pConns) do if c then c:Disconnect() end end
    pConns={}

    for i,ref in ipairs(pool) do
        local di=s1+i-1
        if di<=s2 then
            local d=filtered[di]
            local act=activeKey==d.key
            ref._key=d.key  -- store for hover closure

            ref.btn.Position=UDim2.new(0,0,0,(di-1)*RS)
            ref.btn.Visible=true
            ref.btn.BackgroundColor3=act and P.active or P.raised
            ref.nl.Text=d.name ref.nl.TextColor3=act and P.text or P.textDim
            ref.tl.Text=d.type ref.tl.TextColor3=act and P.accent or P.textDim
            ref.bar.Visible=act

            pConns[i]=ref.btn.MouseButton1Click:Connect(function()
                pcall(function()
                    activeKey=d.key
                    if d.isFullSet then
                        for _,t in ipairs(ORDER) do if d.slots[t] then setAnim(t,d.slots[t]) end end
                        Notify("Full Set",d.name,2)
                    else
                        setAnim(d.type,d.ids)
                        Notify(d.type,d.name,1.8)
                    end
                    lastScrollRow=-1 renderRows()
                end)
            end)
        else
            ref.btn.Visible=false
            ref._key=nil
        end
    end
    list.CanvasSize=UDim2.new(0,0,0,#filtered*RS)
end

local function updateList()
    rebuildFiltered()
    renderRows()
end

local searchThread
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    if searchThread then task.cancel(searchThread) end
    filteredDirty=true
    searchThread=task.delay(0.3,updateList)
end)

-- scroll: only re-render, don't rebuild filter
list:GetPropertyChangedSignal("CanvasPosition"):Connect(renderRows)

local function refreshToggle()
    if isFull then fullBtn.Text="Full Set  ON" fullBtn.TextColor3=P.accent fullBtn.BackgroundColor3=P.active
    else fullBtn.Text="Full Set  OFF" fullBtn.TextColor3=P.textDim fullBtn.BackgroundColor3=P.raised end
end
fullBtn.MouseButton1Click:Connect(function()
    isFull=not isFull filteredDirty=true refreshToggle()
    list.CanvasPosition=Vector2.new(0,0) updateList()
end)

task.delay(0.3,function() loadDB() populateData() updateList() end)

panel.Size=UDim2.new(0,PW,0,0) panel.BackgroundTransparency=1 shadow.BackgroundTransparency=1
task.wait(0.1)
TS:Create(panel,TweenInfo.new(0.38,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,PW,0,PH),BackgroundTransparency=0}):Play()
TS:Create(shadow,TweenInfo.new(0.38),{BackgroundTransparency=0.65}):Play()

Notify("Animations",string.format("loaded in %.2fs",os.clock()-st),2.5)

end)
