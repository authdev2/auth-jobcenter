Config = {}

Config.Framework = "auto" -- options: "auto", "esx", "qbcore", "qbox"

Config.TargetSystem = "marker" -- options: "marker", "ox_target", "qb_target"

Config.NPC = {
    model = "a_m_m_business_01",
    coords = vector4(-264.1702, -965.3143, 31.2238, 205.2605),
    scenario = "WORLD_HUMAN_STAND_MOBILE"
}

Config.Jobs = {
    {
        name = "taxi",
        label = "Taxi Driver",
        salary = 1500,
        description = "Transport passengers around the city",
        icon = "fas fa-taxi"
    },
    {
        name = "police",
        label = "Police Officer",
        salary = 2500,
        description = "Maintain order in the city",
        icon = "fas fa-shield-alt"
    },
    {
        name = "mechanic",
        label = "Mechanic",
        salary = 2000,
        description = "Repair vehicles at the workshop",
        icon = "fas fa-wrench"
    },
    {
        name = "ambulance",
        label = "Doctor",
        salary = 3000,
        description = "Save lives at the hospital",
        icon = "fas fa-ambulance"
    }
}