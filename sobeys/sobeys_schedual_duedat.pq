(banner, stage, daterec)=>
let
    d = try 
    if stage = "Internal Wall Walk" then 
        if banner = "SOBEYS ONTARIO (BASE)" then daterec-#duration(0,20,0,0) else
        if banner = "SOBEYS NFLD" then daterec-#duration(0,20,0,0) else
        if banner = "SOBEYS ATLANTIC" then daterec-#duration(0,20,0,0) else
        if banner = "SOBEYS/SAFEWAY" then daterec-#duration(0,20,0,0) else
        if banner = "SOBEYS URBAN FRESH" then daterec-#duration(0,20,0,0) else
        if banner = "THRIFTY FOODS" then daterec-#duration(0,21,0,0) else
        if banner = "SOBEYS CLARK + HILDA" then daterec else
        if banner = "FOODLAND ONTARIO" then daterec-#duration(0,21,30,0) else
        if banner = "FOODLAND|COOP ATLANTIC" then daterec-#duration(0,21,30,0) else
        if banner = "IGA WEST" then daterec-#duration(0,21,30,0) else
        if banner = "FRESHCO|CHALO WEST" then daterec else
        if banner = "FRESHCO|CHALO ONTARIO" then daterec else
        if banner = "LAWTONS" then daterec-#duration(1,17,0,0) else
        if banner = "LIQUOR" then daterec else daterec
    else if stage = "1st Proofs to Sobeys" then 
        if banner = "SOBEYS ONTARIO (BASE)" then daterec-#duration(0,1,0,0) else
        if banner = "SOBEYS NFLD" then daterec-#duration(0,1,0,0) else
        if banner = "SOBEYS ATLANTIC" then daterec-#duration(0,1,0,0) else
        if banner = "SOBEYS/SAFEWAY" then daterec-#duration(0,1,0,0) else
        if banner = "SOBEYS URBAN FRESH" then daterec-#duration(0,1,0,0) else
        if banner = "THRIFTY FOODS" then daterec-#duration(0,1,0,0) else
        if banner = "IGA WEST" then daterec-#duration(0,1,0,0) else
        if banner = "FOODLAND ONTARIO" then daterec-#duration(0,1,0,0) else
        if banner = "FOODLAND|COOP ATLANTIC" then daterec-#duration(0,1,0,0) else
        if banner = "SOBEYS CLARK + HILDA" then daterec-#duration(0,1,0,0) else daterec
    else if stage = "2nd Proofs to Sobeys" then 
            if banner = "SOBEYS ONTARIO (BASE)" then daterec-#duration(0,4,0,0) else
            if banner = "SOBEYS NFLD" then daterec-#duration(0,4,0,0) else
            if banner = "SOBEYS ATLANTIC" then daterec-#duration(0,4,0,0) else
            if banner = "SOBEYS/SAFEWAY" then daterec-#duration(0,4,0,0) else
            if banner = "SOBEYS URBAN FRESH" then daterec-#duration(0,4,0,0) else
            if banner = "THRIFTY FOODS" then daterec-#duration(0,4,0,0) else
            if banner = "FOODLAND ONTARIO" then daterec-#duration(0,4,0,0) else
            if banner = "FOODLAND|COOP ATLANTIC" then daterec-#duration(0,4,0,0) else
            if banner = "IGA WEST" then daterec-#duration(0,4,0,0) else
            if banner = "FRESHCO|CHALO WEST" then daterec-#duration(0,1,0,0) else
            if banner = "FRESHCO|CHALO ONTARIO" then daterec-#duration(0,1,0,0) else daterec
    else if stage = "3rd Proofs to Sobeys" then 
                if banner = "SOBEYS ONTARIO (BASE)" then daterec-#duration(0,6,0,0) else
                if banner = "SOBEYS NFLD" then daterec-#duration(0,6,0,0) else
                if banner = "SOBEYS ATLANTIC" then daterec-#duration(0,6,0,0) else
                if banner = "SOBEYS/SAFEWAY" then daterec-#duration(0,6,0,0) else
                if banner = "SOBEYS URBAN FRESH" then daterec-#duration(0,6,0,0) else
                if banner = "THRIFTY FOODS" then daterec-#duration(0,6,0,0) else
                if banner = "FOODLAND ONTARIO" then daterec-#duration(0,6,0,0) else
                if banner = "FOODLAND|COOP ATLANTIC" then daterec-#duration(0,6,0,0) else
                if banner = "IGA WEST" then daterec-#duration(0,6,0,0) else
                if banner = "FRESHCO|CHALO WEST" then daterec-#duration(0,16,0,0) else
                if banner = "FRESHCO|CHALO ONTARIO" then daterec-#duration(0,16,0,0) else daterec
    else if stage = "4th Proofs to Sobeys" then 
        if banner = "FRESHCO|CHALO WEST" then daterec-#duration(0,1,0,0) else
        if banner = "FRESHCO|CHALO ONTARIO" then daterec-#duration(0,1,0,0) else
        if banner = "LIQUOR" then daterec-#duration(0,3,0,0) else daterec
    else if stage = "Final Files to Printer" then 
            if banner = "SOBEYS ATLANTIC" then daterec-#duration(0,43,0,0) else
            if banner = "SOBEYS/SAFEWAY" then daterec-#duration(0,1,0,0) else
            if banner = "SOBEYS URBAN FRESH" then daterec-#duration(0,1,0,0) else
            if banner = "THRIFTY FOODS" then daterec-#duration(0,1,0,0) else
            if banner = "IGA WEST" then daterec-#duration(0,1,0,0) else
            daterec
    else if stage = "Translation Due" then 
            if banner = "SOBEYS ONTARIO (BASE)" then daterec+#duration(0,15,0,0) else
            if banner = "SOBEYS NFLD" then daterec+#duration(0,15,0,0) else
            if banner = "SOBEYS ATLANTIC" then daterec+#duration(0,15,0,0) else
            if banner = "FOODLAND ONTARIO" then daterec+#duration(0,15,30,0) else
            if banner = "FOODLAND|COOP ATLANTIC" then daterec+#duration(0,15,30,0) else
            if banner = "FRESHCO|CHALO ONTARIO" then daterec+#duration(0,0,30,0)
            else null
    else if stage = "Produce Grids to SJC" then 
        if banner = "FRESHCO|CHALO WEST" then daterec+#duration(0,0,90,0) else
        if banner = "FRESHCO|CHALO ONTARIO" then daterec+#duration(0,0,90,0) else null else
    daterec otherwise daterec
    
in
    d