--[[----------------------------------------------------------------------------

  Application Name: 01_2dViewer


  Summary:
  Show the distance, intensity and confidence images in three seperate views

  Description:
  Set up the camera to take live images continuously. React to the "OnNewImage"
  event and display the localZ, statemap and color images, each map from the table
  that is passed is shown in the corresponding view.

  How to run:
  First set this app as main (right-click -> "Set as main").
  Start by running the app (F5) or debugging (F7+F10).
  Set a breakpoint on the first row inside the main function to debug step-by-step.
  See the results in the different image viewer on the DevicePage.

  More Information:
  See the tutorials:
  https://supportportal.sick.com/tutorial/visionary-s-ap-first-steps/

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------
-- Variables, constants, serves etc. should be declared here.

--setup the camera and set the configuration to default
local camera = Image.Provider.Camera.create()
Image.Provider.Camera.stop(camera)
local config = Image.Provider.Camera.getDefaultConfig(camera)
Image.Provider.Camera.setConfig(camera, config)

--setup the different views
local viewLocalZ = View.create("localZViewer")
local viewStatemap = View.create("statemapViewer")
local viewColor = View.create("colorViewer")

--setup the pixel value range
local decoLocalZ = View.ImageDecoration.create()
decoLocalZ:setRange(0, 6500)

local decoStatemap = View.ImageDecoration.create()
decoStatemap:setRange(0, 100)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  Image.Provider.Camera.start(camera)
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register("Engine.OnStarted", main)

---@param image Image
---@param sensordata SensorData
local function handleOnNewImage(image)
  View.clear(viewLocalZ)
  View.clear(viewStatemap)
  View.clear(viewColor)

  View.addImage(viewLocalZ, image[1], decoLocalZ)       -- localZ is first element of the image table
  View.addImage(viewStatemap, image[2], decoStatemap)   -- statemap is the third element of the image table
  View.addImage(viewColor, image[3])                    -- color is second element of the image table

  --present the added images
  View.present(viewLocalZ)
  View.present(viewStatemap)
  View.present(viewColor)

end
Image.Provider.Camera.register(camera, "OnNewImage", handleOnNewImage)
--End of Function and Event Scope-----------------------------------------------
