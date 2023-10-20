while true do
    local x, y, z = gps.locate()
    
    if x and y and z then
        print("GPS Coordinates: X = " .. x .. ", Y = " .. y .. ", Z = " .. z)
    else
        print("GPS Coordinates not found.")
    end
    
    sleep(5)  -- Adjust the sleep duration as needed
end
