# US Construction Heatmap (1492-2026)

An interactive visualization showing construction activity across the United States from 1492 to present day.

## Features

### Interactive Timeline
- **Timeline Slider**: Drag to navigate through 534 years of construction history
- **Play/Pause**: Automatic animation through time
- **Speed Control**: Adjust animation speed (1x, 2x, 5x, 10x)
- **Reset Button**: Jump back to 1492

### Visualization
- **Heatmap Layer**: Color-coded density showing construction intensity
  - Blue: Low activity
  - Cyan/Green: Moderate activity
  - Yellow/Orange: High activity
  - Red: Maximum activity
- **Dynamic Filtering**: Only shows construction up to the selected year
- **Age Decay**: Older construction gradually fades to show historical context

### Information Panels
- **Current Year**: Large display of selected year
- **Era Detection**: Automatically identifies historical periods
  - Colonial Era (1492-1600)
  - Revolutionary Era (1776-1800)
  - Gilded Age (1865-1900)
  - Post-War Boom (1945-1970)
  - Modern Era (2000+)
- **Statistics**:
  - Active construction sites in current year
  - Total structures built up to current year

### Historical Data Includes

#### Colonial Period (1492-1700)
- Spanish Landing in Florida (1492)
- St. Augustine (1565)
- Jamestown (1607)
- Plymouth (1620)
- Boston (1630)
- New York (1664)
- Philadelphia (1682)

#### 18th Century
- New Orleans (1718)
- San Francisco (1769)
- Washington DC (1776)

#### 19th Century Expansion
- Louisiana Purchase settlements (1803)
- Chicago (1830)
- Gold Rush California (1850)
- Denver (1858)
- Transcontinental Railroad (1869)

#### 20th Century Boom
- Empire State Building (1931)
- Hoover Dam (1936)
- Interstate Highway System (1956)
- World Trade Center (1973)

#### Modern Era
- Big Dig Boston (2004)
- One World Trade Center (2014)
- Tech Boom (2020s)

## How to Use

1. **Open the file**: Simply open `index.html` in a web browser
2. **Explore the timeline**:
   - Drag the slider to see construction at different time periods
   - Click "Play" to watch construction spread across America
   - Adjust speed for faster/slower animation
3. **Navigate the map**:
   - Zoom in/out with mouse wheel or +/- buttons
   - Pan by clicking and dragging
   - Click on areas to explore specific regions

## Technical Details

### Built With
- **Leaflet.js**: Interactive mapping library
- **Leaflet.heat**: Heatmap visualization plugin
- **CartoDB Dark Matter**: Base map tiles

### Data Generation
The visualization includes:
- 100+ major historical construction sites
- Procedurally generated surrounding development
- Growth patterns around major metropolitan areas
- Accelerating construction density in modern era

### Browser Compatibility
- Chrome/Edge: ✓
- Firefox: ✓
- Safari: ✓
- Mobile browsers: ✓ (responsive design)

## Running Locally

No build process required! Just open `index.html`:

```bash
# Option 1: Direct file open
open index.html

# Option 2: Local server
python -m http.server 8000
# Then visit: http://localhost:8000

# Option 3: Node.js server
npx serve
```

## Future Enhancements

Potential additions:
- Real historical construction data integration
- Detailed tooltips with building information
- Filter by construction type (residential, commercial, infrastructure)
- Export timeline as video
- 3D building height visualization
- Compare multiple time periods side-by-side

## License

Open source - feel free to modify and adapt for your needs.

## Credits

Historical data represents major construction milestones in US history. The visualization demonstrates patterns of westward expansion, urbanization, and modern development.
