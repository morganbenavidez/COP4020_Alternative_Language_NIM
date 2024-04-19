import strutils, streams, os, options, tables, sets

import unittest
import strformat, algorithm
  
type
  Cell = ref object
    oem: string
    model: string
    launchAnnounced: int
    launchStatus: string
    bodyDimensions: string
    bodyWeight: float
    bodySim: string
    displayType: string
    displaySize: float
    displayResolution: string
    featuresSensors: string
    platformOS: string

proc newCell*: Cell =
  new(result)

var cells = initTable[string, Cell]()



# METHODS

# This will delete a cell with a given model name
proc deleteCell(model: string) =
  if model in cells:
    del(cells, model)

# This will check for recent launches and if they're current
proc compareLaunchData(model: string): string =
  let cell = cells[model]
  if "Discontinued" in cell.launchStatus and cell.launchAnnounced >= 2020:
    return "Inconsistent - recent model marked as discontinued"
  elif "Cancelled" in cell.launchStatus:
    return "Check if re-launch planned"
  else:
    return "Consistency check passed"

# This will display an object's details
proc displayDetails(model: string) =
  let cell = cells[model]
  echo "Model: ", cell.model
  echo "OEM: ", cell.oem
  echo "Launch Announced: ", cell.launchAnnounced
  echo "Launch Status: ", cell.launchStatus
  echo "Body Dimensions: ", cell.bodyDimensions
  echo "Body Weight: ", cell.bodyWeight, "g"
  echo "Body SIM: ", cell.bodySim
  echo "Display Type: ", cell.displayType
  echo "Display Size: ", cell.displaySize, " inches"
  echo "Display Resolution: ", cell.displayResolution
  echo "Features & Sensors: ", cell.featuresSensors
  echo "Platform OS: ", cell.platformOS

# This will list unique oems
proc listUniqueOEMs() =
  var uniqueOEMs: HashSet[string]
  for cell in cells.values:
    uniqueOEMs.incl(cell.oem)
  echo "Unique OEMs: ", uniqueOEMs

# This will get the average bodyWeight of a company by oem
proc averageBodyWeightByOEM(targetOEM: string): float =
  var sum: float = 0.0
  var count: int = 0
  for cell in cells.values:
    if cell.oem == targetOEM:
      sum += cell.bodyWeight
      count += 1
  if count > 0:
    return sum / float(count)
  else:
    return 0.0

# This will count the number of feature sensors
proc countFeatureSensors(model: string): int =
  let cell = cells[model]
  if cell.featuresSensors != "null":
    return cell.featuresSensors.split(",").len
  else:
    return 0



# This will find the year with the most launches
proc yearWithMostLaunches(): int =
  var count = initTable[int, int]()  # Initialize the table for year and number of launches
  for cell in cells.values:
    # Check if the year is already a key in the table, if not initialize it to 0 then increment
    if not count.hasKey(cell.launchAnnounced):
      count[cell.launchAnnounced] = 0
    count[cell.launchAnnounced] += 1
  
  var mostLaunches = 0
  var year = 0
  # Iterate through the table to find the year with the most launches
  for k, v in count.pairs:
    if v > mostLaunches:
      mostLaunches = v
      year = k
  
  return year


# FUNCTIONS FOR READ ME

# Function to find the OEM with the highest average weight of phone bodies
proc highestAverageWeightOEM(): string =
  var weightSum = initTable[string, float]()  # 
  var count = initTable[string, int]()        # 
  
  # Populate the tables with the data from each cell
  for cell in cells.values:
    if cell.oem in weightSum:
      weightSum[cell.oem] += cell.bodyWeight
    else:
      weightSum[cell.oem] = cell.bodyWeight
    
    # Similarly, check if the OEM exists in the count table, if not initialize, then increment
    if cell.oem in count:
      count[cell.oem] += 1
    else:
      count[cell.oem] = 1
  
  # Variables to track the maximum average weight and corresponding OEM
  var maxAvgWeight: float = 0.0
  var oemWithMaxWeight: string = ""
  
  # Compute the average weight for each OEM and find the maximum
  for oem, totalWeight in weightSum:
    let avgWeight = totalWeight / float(count[oem])  # Calculate average weight
    if avgWeight > maxAvgWeight:
      maxAvgWeight = avgWeight
      oemWithMaxWeight = oem
  
  return oemWithMaxWeight

#  Phones announced in one year and released in another
proc findAnnouncedReleasedDiscrepancies(): seq[(string, string)] =
  var results: seq[(string, string)]
  for cell in cells.values:
    try:
      let yearReleased = parseInt(cell.launchStatus)
      if yearReleased != cell.launchAnnounced:
        results.add((cell.oem, cell.model))
    except ValueError:
    # If parsing fails, it means launchStatus is not a year
      continue  # Skip to the next iteration
  return results


# Phones with only one feature sensor
proc countPhonesWithOneFeatureSensor(): int =
  var count: int = 0
  for cell in cells.values:
    if cell.featuresSensors != "null" and cell.featuresSensors.split(",").len == 1:
      count += 1
  return count

# Function to find the year with the most phones launched after 1999
proc mostPhonesLaunchedAfter1999(): int =
  var launchCounts = initTable[int, int]()  # 
  for cell in cells.values:
    if cell.launchAnnounced > 1999:
      if cell.launchAnnounced in launchCounts:
        launchCounts[cell.launchAnnounced] += 1
      else:
        launchCounts[cell.launchAnnounced] = 1  # 

  var maxCount: int = 0
  var yearWithMostLaunches: int = 0
  for year, count in launchCounts:
    if count > maxCount:
      maxCount = count
      yearWithMostLaunches = year
  
  return yearWithMostLaunches



# Get and Set Methods

proc getOem(self: Cell): string = self.oem
proc setOem(self: Cell; value: string) = self.oem = value

proc getModel(self: Cell): string = self.model
proc setModel(self: Cell; value: string) = self.model = value

proc getLaunchAnnounced(self: Cell): int = self.launchAnnounced
proc setLaunchAnnounced(self: Cell; value: int) = self.launchAnnounced = value

proc getLaunchStatus(self: Cell): string = self.launchStatus
proc setLaunchStatus(self: Cell; value: string) = self.launchStatus = value

proc getBodyDimensions(self: Cell): string = self.bodyDimensions
proc setBodyDimensions(self: Cell; value: string) = self.bodyDimensions = value

proc getBodyWeight(self: Cell): float = self.bodyWeight
proc setBodyWeight(self: Cell; value: float) = self.bodyWeight = value

proc getBodySim(self: Cell): string = self.bodySim
proc setBodySim(self: Cell; value: string) = self.bodySim = value

proc getDisplayType(self: Cell): string = self.displayType
proc setDisplayType(self: Cell; value: string) = self.displayType = value

proc getDisplaySize(self: Cell): float = self.displaySize
proc setDisplaySize(self: Cell; value: float) = self.displaySize = value

proc getDisplayResolution(self: Cell): string = self.displayResolution
proc setDisplayResolution(self: Cell; value: string) = self.displayResolution = value

proc getFeaturesSensors(self: Cell): string = self.featuresSensors
proc setFeaturesSensors(self: Cell; value: string) = self.featuresSensors = value

proc getPlatformOS(self: Cell): string = self.platformOS
proc setPlatformOS(self: Cell; value: string) = self.platformOS = value


# Function to clean "oem", "model", "bodyDimensions" and "displayType" fields which have similar requirements
proc cleanStringData(data: string): string =
  if data.len == 0 or data == "-":
    return "null"
  else:
    return data

# Function to extract the year from strings
proc extractYear(data: string): string =
  for i in 0 ..< data.len - 4:
    if data[i] in {'0'..'9'} and data[i+1] in {'0'..'9'} and
        data[i+2] in {'0'..'9'} and data[i+3] in {'0'..'9'}:
      return data.substr(i, i+3)
  return "null"

# Function to handle launch status
proc cleanLaunchStatus(data: string): string =
  #let reYear = re"(\d{4})"
  if data in ["Discontinued", "Cancelled"]:
    return data
  return extractYear(data)
  #elif data.matches(reYear):
  #  return data.find(reYear).group(0)
  #else:
  #  return "null"

# Function to parse weight from strings
proc parseWeight(data: string): string =
  var num = ""
  var foundDigit = false
  for ch in data:
    if ch in {'0'..'9'}:
      num.add(ch)
      foundDigit = true
    elif foundDigit and (ch == ' ' or ch == 'g'):
      break
  return if num.len > 0: num else: "null"

# Function to handle SIM card data
proc cleanSimData(data: string): string =
  if data in ["No", "Yes"]:
    return "null"
  else:
    return data

# Function to parse display size and convert it to float
proc parseDisplaySize(data: string): string =
  var num = ""
  var decimalFound = false
  for ch in data:
    if ch in {'0'..'9'}:
      num.add(ch)
    elif ch == '.' and not decimalFound:
      num.add(ch)
      decimalFound = true
    elif decimalFound and ch == ' ':
      break
  return if num.len > 0: num else: "null"

proc customTrim(s: string): string =
  result = s
  while result.len > 0 and result[0] in {' ', '\n', '\t', '\v', '\r'}:
    result = result[1..^1]
  while result.len > 0 and result[^1] in {' ', '\n', '\t', '\v', '\r'}:
    result = result[0..^2]

proc isNumeric(s: string): bool =
  let trimmed = customTrim(s)
  if trimmed.len == 0:
    return false
  for ch in trimmed:
    if not (ch in {'0'..'9'} or ch == '.'):
      return false
  return true

# Function to parse features sensors data
proc cleanFeaturesSensors(data: string): string =
  if data.isNumeric() or customTrim(data) == "":
    return "null"
  else:
    return data


# Function to handle platform OS
proc cleanPlatformOS(data: string): string =
  let idx = data.find(",")
  if idx != -1:
    return data[0..<idx]
  else:
    return data

# Function to safely convert a string to an int
proc safeStringToInt(data: string): int =
  if data.len == 0 or data.toLowerAscii() == "null":
    return -1 # Chose to use -1 for numeric null
  else:
    try:
      let intData = parseInt(data)
      return intData
    except ValueError:
      return -1

# Function to safely convert a string to a float
proc safeStringToFloat(data: string): float =
  if data.len == 0 or data.toLowerAscii() == "null":
    return -1.0 # Chose to use -1.0 for numeric null
  else:
    try:
      let floatData = parseFloat(data)
      return floatData
    except ValueError:
      return -1.0


proc parseCSVLine(line: string): seq[string] =
  var
    result: seq[string]
    currentField: string = ""
    inQuotes: bool = false
  
  for ch in line:
    case ch
    of '"':
      inQuotes = not inQuotes  # Toggle the inQuotes status
    of ',':
      if not inQuotes:
        result.add(if currentField.len > 0: currentField else: "NULL")
        currentField = ""
      else:
        currentField.add(ch)
    else:
      currentField.add(ch)
  
  # Add the last field
  result.add(if currentField.len > 0: currentField else: "NULL")
  
  return result
  
proc readCSVFile(filePath: string) =
  if not fileExists(filePath):
    echo "File not found: ", filePath
    return

  let fileStream = newFileStream(filePath, fmRead)
  if fileStream != nil:
    defer: fileStream.close()
    var counter: int = 0
    for line in fileStream.lines:
      if counter > 0:
        #let fields = line.split(',')
        #echo "Counter: ", counter
        let new_line = parseCSVLine(line)
        if len(new_line) != 12:
          echo "Error"
        else:
          let cell = newCell()
          # I all of these I call the methods that clean the data as I'm setting them.
          cell.setOem(cleanStringData(new_line[0]))
          cell.setModel(cleanStringData(new_line[1]))
          cell.setLaunchAnnounced(safeStringToInt(extractYear(new_line[2])))
          cell.setLaunchStatus(cleanLaunchStatus(new_line[3]))
          cell.setBodyDimensions(cleanStringData(new_line[4]))
          cell.setBodyWeight(safeStringToFloat(parseWeight(new_line[5])))
          cell.setBodySim(cleanSimData(new_line[6]))
          cell.setDisplayType(cleanStringData(new_line[7]))
          cell.setDisplaySize(safeStringToFloat(parseDisplaySize(new_line[8])))
          cell.setDisplayResolution(cleanStringData(new_line[9]))
          cell.setFeaturesSensors(cleanFeaturesSensors(new_line[10]))
          cell.setPlatformOS(cleanPlatformOS(new_line[11]))
          # Converts the counter to a string to use as the key
          let counterStr: string = $counter
          cells[counterStr] = cell
          #echo "Success"
        #echo (len(new_line))
        #echo ('\n')
        #echo len(fields)
      counter += 1
  else:
    echo "Failed to open file."

# Function call to read the csv file
readCSVFile("cells.csv")
var allKeys: seq[string] = @[]
for key in cells.keys:
  allKeys.add(key)
echo "Total number of cells in the table: ", len(cells)

#var someKeys: seq[string] = @["1", "2", "3", "4", "5"]

# This will iterate through every key and print the contents
for key in allKeys:
  let thisCell = cells[key]
  let oemData = thisCell.getOem()
  let modelData = thisCell.getModel()
  let launchAnnouncedData = thisCell.getLaunchAnnounced()
  let launchStatusData = thisCell.getLaunchStatus()
  let bodyDimensionsData = thisCell.getBodyDimensions()
  let bodyWeightData = thisCell.getBodyWeight()
  let bodySimData = thisCell.getBodySim()
  let displayTypeData = thisCell.getDisplayType()
  let displaySizeData = thisCell.getDisplaySize()
  let displayResolutionData = thisCell.getDisplayResolution()
  let featuresSensorsData = thisCell.getFeaturesSensors()
  let platformOSData = thisCell.getPlatformOS()
  
  echo oemData
  echo modelData
  echo launchAnnouncedData
  echo launchStatusData
  echo bodyDimensionsData
  echo bodyWeightData
  echo bodySimData
  echo displayTypeData
  echo displaySizeData
  echo displayResolutionData
  echo featuresSensorsData
  echo platformOSData
  echo "\n"



# This section is to display data for questions on GitHub
let phoneWeight = highestAverageWeightOEM()
echo "Highest average phone weight: ", phoneWeight
echo "\n"
let phoneYears = findAnnouncedReleasedDiscrepancies()
echo "Yes, there were phones announced in one year and released in another. They are: ", phoneYears
echo "\n"
let oneFeatureSensor = countPhonesWithOneFeatureSensor()
echo "Phones with only one feature sensor: ", oneFeatureSensor
echo "\n"
let the_year = mostPhonesLaunchedAfter1999()
echo "The most phones launched after 1999: ", the_year
echo "\n"




# GRAPHING - This creates an html page that has displays the number of phones launched per year.

var launchCounts = initTable[int, int]()

# Assuming 'cells' is a table with your phone data
for cell in cells.values:
# Check if the year key exists, if not, initialize it to 0
  if not launchCounts.hasKey(cell.launchAnnounced):
    launchCounts[cell.launchAnnounced] = 0
  launchCounts[cell.launchAnnounced] += 1

# Collect keys into a sequence
var sortedYears = newSeq[int]()
for year in launchCounts.keys:
  sortedYears.add(year)

sortedYears.sort()
# Find max count for scaling the graph dynamically
var counts = newSeq[int]()
for count in launchCounts.values:
  counts.add(count)
let maxCount = toFloat(counts.max())

# HTML and CSS enhancements
var htmlContent = fmt"""
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Phone Launches Per Year</title>
<style>
.bar-container {{
  width: 60px; /* Adjusted for better alignment */
  display: inline-block;
  vertical-align: bottom; /* Aligns containers to the bottom */
  margin: 5px;
  text-align: center;
}}
.bar {{
width: 100%; /* Makes the bar fill the container */
background-color: #4A90E2;
color: white;
display: block;
}}
.chart {{
border: 1px solid #ccc;
padding: 10px;
background: #f4f4f4; /* Light grey background */
display: flex;
overflow-x: auto;
}}
.year-label {{
margin-top: 5px;
}}

</style>
</head>
<body>
<h1>Phone Launches Per Year</h1>
<div class="chart-container">
<div class="chart">
"""

# Generate bar for each year
for year in sortedYears:
  let count = launchCounts[year]
  let barHeight = int(float(count) / maxCount * 300.0)  # Dynamic scaling based on max count
  htmlContent.add fmt"""
  <div class="bar-container">
  <div class="bar" style="height:{barHeight}px;" title="Year: {year}, Count: {count}">
  {count}
  </div>
  <div class="year-label">
    {year}
  </div>
  </div>
  """

# Close HTML tags
htmlContent.add """
</div>
</div>
</body>
</html>
"""

# Write the HTML content to a file
let fileName = "phone_launches_per_year.html"
writeFile(fileName, htmlContent)

echo "Generated graph at ", getCurrentDir() / fileName



# This section is for unit testing

suite "Cell Management Tests":
  setup:
    # Initialize or reset the cells table before each test if necessary
    cells.clear()
    # You might need to reinitialize cells if it doesn't handle being cleared directly
    cells = initTable[string, Cell]()
  # Test for deleteCell
  test "Delete Cell":
    # Setup
    let cell = newCell()
    cells["testModel"] = cell
    
    # Action
    deleteCell("testModel")
    
    # Check
    check not ("testModel" in cells)

  # Test for compareLaunchData
  test "Compare Launch Data":
    cells.clear()
    # Setup
    let cell = newCell()
    cells["testModel"] = cell
    cell.setOem("TestOEM")
    cell.setModel("TestModel")
    cell.setLaunchAnnounced(2021)
    cell.setLaunchStatus("Discontinued")
    cell.setBodyDimensions("A")
    cell.setBodyWeight(199.0)
    cell.setBodySim("B")
    cell.setDisplayType("C")
    cell.setDisplaySize(44.0)
    cell.setDisplayResolution("D")
    cell.setFeaturesSensors("E")
    cell.setPlatformOS("F")
    
    # Action & Check
    check compareLaunchData("testModel") == "Inconsistent - recent model marked as discontinued"
  
  # Test for displayDetails
  test "Display Details":
    # Setup
    cells.clear()
    let cell = newCell()
    cells["testModel"] = cell
    cell.setOem("TestOEM")
    cell.setModel("TestModel")
    cell.setLaunchAnnounced(2021)
    cell.setLaunchStatus("Discontinued")
    cell.setBodyDimensions("A")
    cell.setBodyWeight(199.0)
    cell.setBodySim("B")
    cell.setDisplayType("C")
    cell.setDisplaySize(44.0)
    cell.setDisplayResolution("D")
    cell.setFeaturesSensors("E")
    cell.setPlatformOS("F")

    displayDetails("testModel")

  
  # Test for listUniqueOEMs
  test "List Unique OEMs":
    # Setup
    cells.clear()
    let cell = newCell()
    cells["testModel1"] = cell
    cell.setOem("TestOEM")
    cell.setModel("TestModel")
    cell.setLaunchAnnounced(2021)
    cell.setLaunchStatus("Discontinued")
    cell.setBodyDimensions("A")
    cell.setBodyWeight(199.0)
    cell.setBodySim("B")
    cell.setDisplayType("C")
    cell.setDisplaySize(44.0)
    cell.setDisplayResolution("D")
    cell.setFeaturesSensors("E")
    cell.setPlatformOS("F")

    let cell2 = newCell()
    cells["testModel1"] = cell2
    cell2.setOem("TestOEM")
    cell2.setModel("TestModel")
    cell2.setLaunchAnnounced(2021)
    cell2.setLaunchStatus("Discontinued")
    cell2.setBodyDimensions("A")
    cell2.setBodyWeight(199.0)
    cell2.setBodySim("B")
    cell2.setDisplayType("C")
    cell2.setDisplaySize(44.0)
    cell2.setDisplayResolution("D")
    cell2.setFeaturesSensors("E")
    cell2.setPlatformOS("F")

    # Action
    listUniqueOEMs()
    
    # Check
  
  # Test for averageBodyWeightByOEM
  test "Average Body Weight By OEM":
    # Setup
    cells.clear()
    let cell = newCell()
    cells["testModel1"] = cell
    cell.setOem("TestOEM")
    cell.setModel("TestModel")
    cell.setLaunchAnnounced(2021)
    cell.setLaunchStatus("Discontinued")
    cell.setBodyDimensions("A")
    cell.setBodyWeight(150.0)
    cell.setBodySim("B")
    cell.setDisplayType("C")
    cell.setDisplaySize(44.0)
    cell.setDisplayResolution("D")
    cell.setFeaturesSensors("E")
    cell.setPlatformOS("F")
    
    let cell2 = newCell()
    cells["testModel2"] = cell2
    cell2.setOem("TestOEM")
    cell2.setModel("TestModel2")
    cell2.setLaunchAnnounced(2021)
    cell2.setLaunchStatus("Discontinued")
    cell2.setBodyDimensions("A")
    cell2.setBodyWeight(100.0)
    cell2.setBodySim("B")
    cell2.setDisplayType("C")
    cell2.setDisplaySize(44.0)
    cell2.setDisplayResolution("D")
    cell2.setFeaturesSensors("E")
    cell2.setPlatformOS("F")
    
    # Action & Check
    let avgWeight = averageBodyWeightByOEM("TestOEM")
    if avgWeight == 125.0:
      echo "weight average passed."
  
  # Test for countFeatureSensors
  test "Count Feature Sensors":
    # Setup
    cells.clear()
    let cell = newCell()
    cells["testModel1"] = cell
    cell.setOem("TestOEM")
    cell.setModel("TestModel")
    cell.setLaunchAnnounced(2021)
    cell.setLaunchStatus("Discontinued")
    cell.setBodyDimensions("A")
    cell.setBodyWeight(150.0)
    cell.setBodySim("B")
    cell.setDisplayType("C")
    cell.setDisplaySize(44.0)
    cell.setDisplayResolution("D")
    cell.setFeaturesSensors("Camera,GPS,Bluetooth")
    cell.setPlatformOS("F")
    
    # Action & Check
    check countFeatureSensors("testModel1") == 3
  
  # Test for yearWithMostLaunches
  test "Year with Most Launches":
    # Setup
    cells.clear()
    let cell = newCell()
    cells["testModel1"] = cell
    cell.setOem("TestOEM")
    cell.setModel("TestModel")
    cell.setLaunchAnnounced(2021)
    cell.setLaunchStatus("Discontinued")
    cell.setBodyDimensions("A")
    cell.setBodyWeight(150.0)
    cell.setBodySim("B")
    cell.setDisplayType("C")
    cell.setDisplaySize(44.0)
    cell.setDisplayResolution("D")
    cell.setFeaturesSensors("E")
    cell.setPlatformOS("F")
    
    let cell2 = newCell()
    cells["testModel2"] = cell2
    cell2.setOem("TestOEM")
    cell2.setModel("TestModel2")
    cell2.setLaunchAnnounced(2021)
    cell2.setLaunchStatus("Discontinued")
    cell2.setBodyDimensions("A")
    cell2.setBodyWeight(100.0)
    cell2.setBodySim("B")
    cell2.setDisplayType("C")
    cell2.setDisplaySize(44.0)
    cell2.setDisplayResolution("D")
    cell2.setFeaturesSensors("E")
    cell2.setPlatformOS("F")
    
    let cell3 = newCell()
    cells["testModel3"] = cell3
    cell3.setOem("TestOEM")
    cell3.setModel("TestModel")
    cell3.setLaunchAnnounced(2020)
    cell3.setLaunchStatus("Discontinued")
    cell3.setBodyDimensions("A")
    cell3.setBodyWeight(150.0)
    cell3.setBodySim("B")
    cell3.setDisplayType("C")
    cell3.setDisplaySize(44.0)
    cell3.setDisplayResolution("D")
    cell3.setFeaturesSensors("E")
    cell3.setPlatformOS("F")
    
    # Action & Check
    check yearWithMostLaunches() == 2021