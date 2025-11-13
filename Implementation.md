# Implementation Plan and Progress

**Crime-Aware Navigation App**  
**Team:** Dhruv Khut, Mohibkhan Pathan, Monesh Pulla, Naga Lakshmi Gurrala, Rahul Dhingra  
**Date:** November 12, 2025

---

## Environment Setup

A flexible, file-based development environment is being established to support crime-aware routing, risk modeling, and interactive web visualization for pedestrian safety in San Francisco.

| Layer | Candidate Technologies / Status |
|-------|--------------------------------|
| **Programming Language** | **Python 3.11-3.12** (for backend, data processing, and routing algorithms) |
| **Graph & Routing Framework** | Using **OSMnx 2.0.6** for OpenStreetMap graph extraction; **NetworkX ≥3.4** for shortest-path algorithms (Dijkstra/A*) |
| **Backend Service** | **FastAPI ≥0.110** with **Uvicorn[standard] ≥0.30** for RESTful API endpoints (geocoding, route computation) |
| **Frontend** | **Leaflet.js** (JavaScript mapping library) for interactive web maps with custom route overlays |
| **Geospatial Processing** | **GeoPandas ≥1.0**, **Shapely ≥2.0**, **PyProj ≥3.6** for spatial operations; **Rtree ≥1.2.0** for spatial indexing |
| **Data Storage** | **File-based**: GraphML for road networks, **Parquet (PyArrow ≥14.0)** for edge risk scores, CSV for incident data; **No database required** for MVP |
| **Machine Learning** | Evaluating **XGBoost** or **scikit-learn (Logistic Regression)** for risk classification; **scikit-learn ≥1.5** for feature engineering |
| **Visualization** | **Matplotlib ≥3.8** for static plots; **Folium ≥0.16** for interactive HTML maps; **Leaflet** for web UI |
| **Development Environment** | Local development with **virtualenv (.venv)**; one-command setup via `requirements.txt` or **Makefile**; **macOS/Linux** tested |
| **Version Control & Deployment** | **GitHub** for source control; **Docker** (optional) for containerization; artifacts versioned with timestamps and checksums |

---

## Technology Stack Details

### Core Dependencies

```txt
# Geospatial & Routing
osmnx==2.0.6
networkx>=3.4
geopandas>=1.0
shapely>=2.0
pyproj>=3.6
rtree>=1.2.0

# Data Processing
pandas>=2.2
pyarrow>=14.0
tqdm>=4.66

# Visualization
matplotlib>=3.8
folium>=0.16

# Machine Learning
scikit-learn>=1.5
# xgboost (optional, fallback to LogReg if unavailable)

# API Server
fastapi>=0.110
uvicorn[standard]>=0.30
requests>=2.31  # for Nominatim geocoding
```

### Architecture Layers

**1. Data Layer**
- **SFPD Incident Data**: Historical crime reports (CSV) from San Francisco Open Data Portal
- **OSM Road Network**: Street graph extracted via OSMnx, cached as GraphML
- **Risk Scores**: Per-edge risk computed offline, stored as Parquet

**2. Processing Layer**
- **Risk Modeling**: Hotspot detection (K-Means/DBSCAN), temporal conditioning, recency decay
- **Feature Engineering**: Incident→edge attribution, spatial indexing with Rtree
- **Route Computation**: Modified Dijkstra with composite cost `w = α·time + β·risk`

**3. API Layer**
- **FastAPI Backend**: RESTful endpoints for geocoding and route computation
- **Endpoints**: `/api/geocode`, `/api/route`
- **Response Time Target**: ≤5s P95 for route requests

**4. Presentation Layer**
- **Web UI**: HTML/CSS/JavaScript with Leaflet.js
- **Features**: Place search, 3-route comparison, risk overlay toggle
- **Mobile-responsive design**

---

## Development Workflow

### Setup (One-Time)

```bash
# 1. Clone repository
git clone <repo-url>
cd CrimeAwareNavigationApp

# 2. Create virtual environment
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate

# 3. Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# 4. Verify installation
python -c "import osmnx, networkx, geopandas; print('Setup complete')"
```

### Data Pipeline

```bash
# Fetch SFPD data (optional, sample included)
python -m src.etl.fetch_sfpd_api --full-city --out data_raw/sfpd_full_city.csv

# Build full SF graph (~5-10 min first run)
python -m src.graph.build_full_graph

# Compute risk scores (~10-30 min)
python -m src.risk.simple_recency_risk \
  --csv data_raw/sfpd_full_city.csv \
  --graph data_proc/graph_sf_full.graphml \
  --out data_proc/edge_risk_full.parquet
```

### Running the Application

```bash
# Terminal 1: Start API server
python -m src.api.server --host 0.0.0.0 --port 8000

# Terminal 2: Start web server
cd web && python -m http.server 8001

# Open browser: http://localhost:8001/app.html
```

---

## Environment Configuration

### `.env` File (Not Committed)

```bash
# API Keys (if needed for future enhancements)
# MAPBOX_TOKEN=your_token_here
# OPENWEATHER_API_KEY=your_key_here

# Application Settings
API_HOST=0.0.0.0
API_PORT=8000
LOG_LEVEL=INFO

# Data Paths
GRAPH_PATH=data_proc/graph_sf_full.graphml
RISK_PATH=data_proc/edge_risk_full.parquet
INCIDENT_DATA=data_raw/sfpd_full_city.csv
```

### System Requirements

- **Python**: 3.11 or 3.12 recommended
- **OS**: macOS or Linux (Windows with WSL)
- **RAM**: 4GB minimum, 8GB recommended for full-city graph
- **Disk**: ~500MB for dependencies, ~2GB for data artifacts
- **Network**: Required for initial OSM download and geocoding API

---

## Progress Tracking

| Task | Status (Nov 2025) | Notes |
|------|-------------------|-------|
| **Environment Setup & Dependencies** | Completed | Python 3.11 environment active; virtualenv configured; all geospatial libraries installed and tested |
| **Sample SFPD Data Integration** | Completed | Downtown sample (~13k rows) integrated; data schema validated; CSV processing pipeline operational |
| **Small Downtown SF Graph (S1)** | Completed | 2×2 km subgraph built with 399 nodes, 845 edges; OSMnx caching functional; basic routing demo working |
| **Full SF Graph Builder (S2)** | Completed | Full-city graph with 10,020 nodes and 27,464 edges; GraphML cached; ~5-10 min build time verified |
| **Full-City SFPD Data Fetch** | Completed | 365-day historical data (~400k incidents) fetched and cleaned; schema documented with timestamp |
| **Simple Recency-Based Risk Scoring** | Completed | Exponential decay model implemented; edge risk scores computed; Parquet storage functional |
| **Incident→Edge Attribution** | Completed | Spatial indexing with Rtree operational; buffer/nearest-edge snapping working; per-edge incident counts generated |
| **FastAPI Backend with Geocoding** | Completed | RESTful API endpoints operational; Nominatim geocoding integrated; CORS configured for local dev |
| **Interactive Web UI** | Completed | Leaflet.js map with place search; autocomplete functional; mobile-responsive design implemented |
| **Fastest vs Safest Routing** | Completed | Two-route comparison working; Δtime/Δrisk displayed; route visualization on map functional |
| **Static & Interactive Visualizations** | Completed | Matplotlib PNG plots and Folium HTML maps generated; route rendering verified |
| **Hotspot Detection (K-Means/DBSCAN)** | In Progress | Evaluating clustering algorithms for crime hotspot identification; proximity features in development |
| **Temporal Conditioning (Hour/Day)** | In Progress | Implementing time-of-day and day-of-week binning; recency decay weighting being refined |
| **Incident Type Weighting** | In Progress | Categorizing incidents (theft, assault, etc.); developing severity weights for risk scoring |
| **Feature Engineering Pipeline** | In Progress | Building edge_features.parquet with hotspot proximity, temporal bins, and incident weights |
| **Risk Classifier Training (ML)** | Planned | To be implemented in S4; evaluating XGBoost vs Logistic Regression for normalized risk scores [0,1] |
| **Balanced Route Algorithm** | Planned | Composite cost w=α·time+β·risk to be implemented; α=0.5, β=0.5 for balanced option |
| **Time Budget Constraint** | Planned | User-defined max detour (Tmax) enforcement; constraint: travel_time ≤ Tmax |
| **Safety Margin Constraint** | Planned | Minimum safety threshold enforcement; constraint: user_threshold − route_risk > 0 |
| **3-Route API Endpoint** | Planned | FastAPI endpoint to return Fastest/Balanced/Safest with time and risk totals; scheduled for S4 |
| **Plain-Language Explanations** | Planned | Rule-based explanation generator; e.g., "avoids blocks with 3 recent theft reports"; scheduled for S5 |
| **High-Risk Segment Alerts** | Planned | Alert system for paths crossing newly high-risk segments; threshold-based detection; scheduled for S5 |
| **User Preference UI** | Planned | Time budget and safety threshold sliders; preference controls in web UI; scheduled for S6 |
| **3-Route Comparison View** | Planned | Enhanced UI displaying Fastest/Balanced/Safest with clear deltas; scheduled for S6 |
| **Risk Overlay Toggle** | Planned | Interactive map layer showing segment-level risk; toggle control in UI; scheduled for S6 |
| **Evaluation Framework (50 O-D Pairs)** | Planned | Batch evaluation script; metrics: % risk reduction, minutes per 10% risk reduction; scheduled for S7 |
| **Latency Benchmarking** | Planned | Performance testing to verify ≤5s P95 target; scheduled for S7 |
| **Robustness & Error Handling** | Planned | Cached fallbacks, graceful degradation, comprehensive error handling; scheduled for S8 |
| **Data Refresh Pipeline** | Planned | End-to-end refresh script with versioning; `make refresh` command; scheduled for S9 |
| **Operations & Monitoring** | Planned | Request timing, error logging, metrics dashboard, runbook; scheduled for S10 |
| **POI Density Feature (Optional)** | Planned | OSM points-of-interest integration to distinguish isolated vs busy corridors; stretch goal for S11 |
| **Final Evaluation & Metrics** | Planned | Complete metrics collection, final plots, demo script; scheduled for S12-S13 |

---

**Last Updated:** November 12, 2025  
**Current Sprint:** S2 (Data & Graph Baseline)  
**Next Sprint:** S3 (Risk Features v1) - Starting Sep 30, 2025
