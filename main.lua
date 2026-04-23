local base = "https://raw.githubusercontent.com/bonorbom/WHYNOT-/main/"

_G.BON = {}

_G.BON.Fly = loadstring(game:HttpGet(base .. "Fly.lua"))()
loadstring(game:HttpGet(base .. "HUD.lua"))()