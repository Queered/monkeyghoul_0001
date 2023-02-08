getgenv().Orbit = {
    OrbitW = {
      Bind = "Z",
      Enabled = true,
      Part = "HumanoidRootPart",
      NearestCursor = true,
      HitChance = false,
      HitChancePower = 100,
      Setting = 0.19, 
      WallCheck = false,
      Knockedcheck = false,
	  AutoResolve = false,
        Positive = 80,
        Negative = -40
  
    },
    OrbitCam = {
        Enabled = true,
        AimPart = "HumanoidRootPart,
        Smoothness = true,
        SmoothnessValue = 0.1,
        PredictionValue = 000.817,
        Shake = false,
        ShakeAmount = 0.12,
        CheckIfJumped = false,
        ClosestTracerPart = true,
        AirShotPart = "RightFoot",
        UnlockOnPlayerDeath = true,
        UnlockOnTargetDeath = false,
        AirShotfunction = false,
        DetectAnyAA = false,
        KeyBind = "C",
        SeeFov = true,
        Radius = 90,
        PersonRadius = true,
        UseAutoVelocity = false,
  
      },
      OrbitFov = {
          OrbitRadius = 25,
          Visible = true,
          Fov_Filled = true,
          UseFovSides = false,
          FovSides = 100,
          Colors = Color3.fromRGB(1, 131, 232),
  
        },
        OrbitMisc = {
  
          MemorySpoofer = false,
          MemoryStart = 800,
          MemoryEnd = 900,
          PingSpoofer = false,
          PingStart = 10,
          PingEnd = 100,
          PingSpeed = 2,
          MemorySpeed = 1,
        },
    } 

          
        
        
  
if not LPH_OBFUSCATED then
    LPH_JIT_MAX = function(...)
        return (...)
    end
    LPH_NO_VIRTUALIZE = function(...)
        return (...)
    end
end

LPH_JIT_MAX(
    function()
        local Players, Client, Mouse, RS, Camera, r =
            game:GetService("Players"),
            game:GetService("Players").LocalPlayer,
            game:GetService("Players").LocalPlayer:GetMouse(),
            game:GetService("RunService"),
            game.Workspace.CurrentCamera,
            math.random

        local Circle = Drawing.new("Circle")
        Circle.Color = Color3.new(1, 1, 1)
        Circle.Transparency = 0.5
        Circle.Thickness = 1

        local OrbitCamCircle = Drawing.new("Circle")
        OrbitCamCircle.Color = Color3.new(1, 1, 1)
        OrbitCamCircle.Thickness = 1

        local prey
        local prey2
        local On

        local Vec2 = function(property)
            return Vector2.new(property.X, property.Y + (game:GetService("GuiService"):GetGuiInset().Y))
        end

        local UpdateSilentFOV = function()
            if not Circle then
                return Circle
            end
            Circle.Visible = getgenv().Orbit.OrbitFov["Visible"]
            Circle.Radius = getgenv().Orbit.OrbitFov["OrbitRadius"] * 3.05
            Circle.Position = Vec2(Mouse)

            return Circle
        end

        local UpdateTracerFOV = function()
            if not OrbitCamCircle then
                return OrbitCamCircle
            end

            OrbitCamCircle.Visible = getgenv().Orbit.OrbitCam["SeeFov"]
            OrbitCamCircle.Radius = getgenv().Orbit.OrbitCam["Radius"]
            OrbitCamCircle.Position = Vec2(Mouse)

            return OrbitCamCircle
        end

        game.RunService.RenderStepped:Connect(function ()
            UpdateTracerFOV()
            UpdateSilentFOV()
        end)

        local WallCheck = function(destination, ignore)
            if getgenv().Orbit.OrbitW.WallCheck then
                local Origin = Camera.CFrame.p
                local CheckRay = Ray.new(Origin, destination - Origin)
                local Hit = game.workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
                return Hit == nil
            else
                return true
            end
        end

        local useVelocity = function (player) 
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0.36, 0.21, 0.34) * 2
        end

        local checkVelocity = function (player, pos, neg)
            if player and player.Character:FindFirstChild("Humanoid") then
                local velocity = player.Character.HumanoidRootPart.Velocity
                if (velocity.Magnitude > neg or velocity.Magnitude < pos and
                (not player.Character.Humanoid.Jump == true)) then
                    useVelocity(player)
                end
            end
            return false
        end

        task.spawn(function () while task.wait() do if getgenv().Orbit.OrbitW.AutoResolve == true then checkVelocity(prey or prey2, getgenv().Orbit.OrbitW.Positive, getgenv().Orbit.OrbitW.Negative) end end end)

        GetClosestToMouse = function()
            local Target, Closest = nil, 1 / 0

            for _, v in pairs(Players:GetPlayers()) do
                if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
                    local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                    if
                        (Circle.Radius > Distance and Distance < Closest and OnScreen and
                            WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}))
                     then
                        Closest = Distance
                        Target = v
                    end
                end
            end
            return Target
        end

        function TargetChecks(Target)
            if getgenv().Orbit.Extras.UnlockedOnDeath == true and Target.Character then
                return Target.Character.BodyEffects["K.O"].Value and true or false
            end
            return false
        end

        function PredictionictTargets(Target, Value)
            return Target.Character[getgenv().Orbit.OrbitW.Part].CFrame +
                (Target.Character[getgenv().Orbit.OrbitW.Part].Velocity * Value)
        end

        local WTS = function(Object)
            local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
            return Vector2.new(ObjectVector.X, ObjectVector.Y)
        end

        local IsOnScreen = function(Object)
            local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
            return IsOnScreen
        end

        local FilterObjs = function(Object)
            if string.find(Object.Name, "Gun") then
                return
            end
            if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
                return true
            end
        end
        GetClosestBodyPart = function(character)
            local ClosestDistance = 1 / 0
            local BodyPart = nil
            if (character and character:GetChildren()) then
                for _, x in next, character:GetChildren() do
                    if FilterObjs(x) and IsOnScreen(x) then
                        local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if getgenv().Orbit.OrbitCam.PersonRadius == true then
                            if (OrbitCamCircle.Radius > Distance and Distance < ClosestDistance) then
                                ClosestDistance = Distance
                                BodyPart = x
                            end
                        else
                            if (Distance < ClosestDistance) then
                                ClosestDistance = Distance
                                BodyPart = x
                            end
                        end
                    end
                end
            end
            return BodyPart
        end

        Mouse.KeyDown:Connect(
            function(Key)
                if (Key == getgenv().Orbit.OrbitCam.KeyBind:lower()) then
                    if getgenv().Orbit.OrbitCam.Enabled == true then
                        On = not On
                        if On then
                            prey2 = GetClosestToMouse()
                        else
                            if prey2 ~= nil then
                                prey2 = nil
                            end
                        end
                    end
                end
                if (Key == getgenv().Orbit.OrbitW.Bind:lower()) then
                    if getgenv().Orbit.OrbitW.Enabled == true then
                        getgenv().Orbit.OrbitW.Enabled = false
                    else
                        getgenv().Orbit.OrbitW.Enabled = true
                    end
                end
            end
        )

        RS.RenderStepped:Connect(
            function()
                if prey then
                    if prey ~= nil and getgenv().Orbit.OrbitW.Enabled and getgenv().Orbit.OrbitW.NearestCursor == true then
                        getgenv().Orbit.OrbitW["Part"] = tostring(GetClosestBodyPart(prey.Character))
                    end
                end
                if prey2 then
                    if
                        prey2 ~= nil and not TargetChecks(prey2) and getgenv().Orbit.TrOrbitCamacer.Enabled and
                            getgenv().Orbit.OrbitCam.ClosestTracerPart == true
                     then
                        getgenv().Orbit.OrbitCam["AimPart"] = tostring(GetClosestBodyPart(prey2.Character))
                    end
                end
            end
        )

        local OrbitCamPredictioniction = function(Target, Value)
            return Target.Character[getgenv().Orbit.OrbitCam.AimPart].Position +
                (Target.Character[getgenv().Orbit.OrbitCam.AimPart].Velocity / Value)
        end

        RS.RenderStepped:Connect(
            function()
                if
                    prey2 ~= nil and not TargetChecks(prey2) and getgenv().Orbit.OrbitCam.Enabled and
                        getgenv().Orbit.OrbitCam.Smoothness == true
                 then
                    local Main = CFrame.new(Camera.CFrame.p, OrbitCamPredictioniction(prey2, getgenv().Orbit.OrbitCam.PredictionValue))
                    Camera.CFrame =
                        Camera.CFrame:Lerp(
                        Main,
                        getgenv().Orbit.OrbitCam.SmoothnessValue,
                        Enum.EasingStyle.Elastic,
                        Enum.EasingDirection.InOut,
                        Enum.EasingStyle.Sine,
                        Enum.EasingDirection.Out
                    )
                elseif prey2 ~= nil and getgenv().Orbit.OrbitCam.Enabled and getgenv().Orbit.OrbitCam.Smoothness == false then
                    Camera.CFrame =
                        CFrame.new(Camera.CFrame.Position, OrbitCamPredictioniction(prey2, getgenv().Orbit.OrbitCam.PredictionValue))
                end
            end
        )

        local grmt = getrawmetatable(game)
        local index = grmt.__index
        local properties = {
            "Hit" -- Ill Add more Mouse properties soon,
        }
        setreadonly(grmt, false)

        grmt.__index =
            newcclosure(
            function(self, v)
                if Mouse and (table.find(properties, v)) then
                    prey = GetClosestToMouse()
                    if prey ~= nil and getgenv().Orbit.OrbitW.Enabled and not TargetChecks(prey) then
                        local endpoint = PredictionictTargets(prey, getgenv().Orbit.OrbitW.Setting)

                        return (table.find(properties, tostring(v)) and endpoint)
                    end
                end
                return index(self, v)
            end
        )
    end
)()
