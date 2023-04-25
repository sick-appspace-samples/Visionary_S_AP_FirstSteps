--[[----------------------------------------------------------------------------

  Application Name: 02_3dViewer
                                                                                             
  Summary:
  Show how to calculate a full pointcloud and visualize
  
  Description:
  Set up the camera to take live images continuously and automatically calculate
  pointclouds out of it. The Z image is converted to a pointcloud to be visualized.
  React to the "OnNewImage" event and show the pointcloud in an 3D viewer.
  
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

--setup the camera, set the configuration to default and get the camera model
local camera = Image.Provider.Camera.create()
Image.Provider.Camera.stop(camera)
local config = Image.Provider.Camera.getDefaultConfig(camera)
Image.Provider.Camera.setConfig(camera, config)
local cameraModel = Image.Provider.Camera.getInitialCameraModel(camera)

--setup the pointcloud converter
local pointCloudConverter = Image.PointCloudConversion.PlanarDistance.create()
pointCloudConverter:setCameraModel(cameraModel)

--setup the  view
local view3D = View.create("3DViewer")

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  Image.Provider.Camera.start(camera)
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event 
Script.register("Engine.OnStarted", main)

--@handleOnNewImage(image:Image,sensordata:SensorData)
local function handleOnNewImage(image)
  --convert to point cloud using the z-map/distance image
  --add the point cloud to the viewer and then present
  local convert = Image.PointCloudConversion.PlanarDistance.toPointCloud(pointCloudConverter, image[1],image[1])
  View.clear(view3D)
  View.addPointCloud(view3D, convert)
  View.present(view3D)
end
Image.Provider.Camera.register(camera, "OnNewImage", handleOnNewImage)
--End of Function and Event Scope-----------------------------------------------
