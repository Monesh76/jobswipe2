# WB2-9. Project Schedule

**Crime-Aware Navigation App**  
**Team:** Dhruv Khut, Mohibkhan Pathan, Monesh Pulla, Naga Lakshmi Gurrala, Rahul Dhingra  
**Date:** November 12, 2025  
**Advisor:** Dr. Ali Arsanjani

---

## 1. Project Timeline Overview

**Duration:** 8 months (Sep 2025 - May 2026)  
**Structure:** 13 two-week sprints across 2 semesters

### Semester 1: Foundation (Sep - Dec 2025)
- **S1-S6:** Core features, routing engine, web UI
- **Focus:** MVP with Fastest/Balanced/Safest routing

### Semester 2: Production (Feb - May 2026)
- **S7-S13:** Evaluation, robustness, polish, delivery
- **Focus:** Testing, optimization, final delivery

---

## 2. Sprint Summary Table

| Sprint | Dates | Focus | Lead Owner | Critical Path |
|--------|-------|-------|------------|---------------|
| **S1** | Sep 2-15 | Environment Setup | Mohib | ✅ Yes |
| **S2** | Sep 16-29 | Data & Graph | Dhruv | ✅ Yes |
| **S3** | Sep 30-Oct 13 | Risk Features | Rahul | ✅ Yes |
| **S4** | Oct 14-27 | 3-Route Engine | Dhruv | ✅ Yes |
| **S5** | Oct 28-Nov 10 | Explainability | Naga Lakshmi | ✅ Yes |
| **S6** | Nov 11-24 | Web UI | Monesh | ❌ No (7d slack) |
| - | Dec-Jan | **WINTER BREAK** | - | - |
| **S7** | Feb 3-16 | Evaluation | Naga Lakshmi | ✅ Yes |
| **S8** | Feb 17-Mar 2 | Robustness | Dhruv | ❌ No (5d slack) |
| **S9** | Mar 3-16 | Data Pipeline | Dhruv | ✅ Yes |
| **S10** | Mar 17-30 | Operations | Mohib | ❌ No (7d slack) |
| **S11** | Mar 31-Apr 13 | Polish | Monesh | ❌ No (10d slack) |
| **S12** | Apr 14-27 | Stabilization | All | ✅ Yes |
| **S13** | Apr 28-May 11 | Final Delivery | All | ✅ Yes |

---

## 3. Gantt Chart

### Semester 1 (September - December 2025)

```
Sprint  September   October     November    December
        |----|----|----|----|----|----|----|----|----|
S1      [====]                                          Environment Setup (Mohib)
S2           [====]                                     Data & Graph (Dhruv)
S3                [====]                                Risk Features (Rahul)
S4                     [====]                           3-Route Engine (Dhruv)
S5                          [====]                      Explainability (Naga Lakshmi)
S6                               [----]                 Web UI (Monesh)
        |----|----|----|----|----|----|----|----|----|
         2  16 30 14 28 11 25  9  23  7  21  5  19

Legend: [====] Critical Path    [----] Non-Critical (has slack time)
```

### Semester 2 (February - May 2026)

```
Sprint  February    March       April       May
        |----|----|----|----|----|----|----|----|----|
S7      [====]                                          Evaluation (Naga Lakshmi)
S8           [----]                                     Robustness (Dhruv)
S9                [====]                                Data Pipeline (Dhruv)
S10                    [----]                           Operations (Mohib)
S11                         [----]                      Polish (Monesh)
S12                              [====]                 Stabilization (All)
S13                                   [====]            Final Delivery (All)
        |----|----|----|----|----|----|----|----|----|
         3  17  3  17 31 14 28 12 26 10

Legend: [====] Critical Path    [----] Non-Critical (has slack time)
```

### Full Project Visual Timeline

```
2025                                                    2026
Sep   Oct   Nov   Dec | Jan | Feb   Mar   Apr   May
[S1][S2][S3][S4][S5][S6]|BREAK|[S7][S8][S9][S10][S11][S12][S13]
 ↓    ↓    ↓    ↓    ↓    ↓          ↓    ↓    ↓     ↓     ↓     ↓     ↓
Setup Data Risk Route Expl  UI      Eval Robust Pipe  Ops  Polish Stab Final
```

---

## 4. PERT Chart (Network Diagram)

### Complete Dependency Network

```
                    START
                      │
                      ↓
                ┌─────────┐
                │   S1    │  Environment Setup
                │ 2 weeks │  Lead: Mohib
                │ (CRIT)  │  All team members
                └─────────┘
                      │
                      ↓
                ┌─────────┐
                │   S2    │  Data & Graph
                │ 2 weeks │  Lead: Dhruv
                │ (CRIT)  │  Depends: S1
                └─────────┘
                      │
                      ↓
                ┌─────────┐
                │   S3    │  Risk Features
                │ 2 weeks │  Lead: Rahul
                │ (CRIT)  │  Depends: S2
                └─────────┘
                      │
                      ↓
                ┌─────────┐
                │   S4    │  3-Route Engine
                │ 2 weeks │  Lead: Dhruv
                │ (CRIT)  │  Depends: S3
                └─────────┘
                      │
                      ↓
                ┌─────────┐
          ┌─────│   S5    │─────┐
          │     │ 2 weeks │     │  Explainability
          │     │ (CRIT)  │     │  Lead: Naga Lakshmi
          │     └─────────┘     │  Depends: S4
          │           │         │
          │           ↓         │
          │     ┌─────────┐     │
          └─────│   S6    │─────┘  Web UI
                │ 2 weeks │        Lead: Monesh
                │ (SLACK) │        Depends: S5
                └─────────┘        Slack: 7 days
                      │
                      ↓
              [WINTER BREAK]
                      │
                      ↓
                ┌─────────┐
                │   S7    │  Evaluation
                │ 2 weeks │  Lead: Naga Lakshmi
                │ (CRIT)  │  Depends: S6
                └─────────┘
                      │
                      ↓
                ┌─────────┐
          ┌─────│   S8    │─────┐
          │     │ 2 weeks │     │  Robustness
          │     │ (SLACK) │     │  Lead: Dhruv
          │     └─────────┘     │  Depends: S7
          │           │         │  Slack: 5 days
          │           ↓         │
          │     ┌─────────┐     │
          └─────│   S9    │─────┘  Data Pipeline
                │ 2 weeks │        Lead: Dhruv
                │ (CRIT)  │        Depends: S8
                └─────────┘
                      │
                      ↓
                ┌─────────┐
          ┌─────│  S10    │─────┐
          │     │ 2 weeks │     │  Operations
          │     │ (SLACK) │     │  Lead: Mohib
          │     └─────────┘     │  Depends: S9
          │           │         │  Slack: 7 days
          │           ↓         │
          │     ┌─────────┐     │
          └─────│  S11    │─────┘  Polish
                │ 2 weeks │        Lead: Monesh
                │ (SLACK) │        Depends: S10
                └─────────┘        Slack: 10 days
                      │
                      ↓
                ┌─────────┐
                │  S12    │  Stabilization
                │ 2 weeks │  Lead: All
                │ (CRIT)  │  Depends: S11
                └─────────┘
                      │
                      ↓
                ┌─────────┐
                │  S13    │  Final Delivery
                │ 2 weeks │  Lead: All
                │ (CRIT)  │  Depends: S12
                └─────────┘
                      │
                      ↓
                     END
```

### Critical Path Analysis

**Critical Path:** S1 → S2 → S3 → S4 → S5 → S7 → S9 → S12 → S13

**Total Duration:** 26 weeks (13 sprints × 2 weeks)
**Critical Path Duration:** 18 weeks (9 critical sprints)
**Available Slack:** 8 weeks across 4 non-critical sprints

| Sprint | Total Float | Free Float | On Critical Path? |
|--------|-------------|------------|-------------------|
| S1 | 0 days | 0 days | ✅ Yes |
| S2 | 0 days | 0 days | ✅ Yes |
| S3 | 0 days | 0 days | ✅ Yes |
| S4 | 0 days | 0 days | ✅ Yes |
| S5 | 0 days | 0 days | ✅ Yes |
| S6 | 7 days | 7 days | ❌ No |
| S7 | 0 days | 0 days | ✅ Yes |
| S8 | 5 days | 5 days | ❌ No |
| S9 | 0 days | 0 days | ✅ Yes |
| S10 | 7 days | 7 days | ❌ No |
| S11 | 10 days | 10 days | ❌ No |
| S12 | 0 days | 0 days | ✅ Yes |
| S13 | 0 days | 0 days | ✅ Yes |

---

## 5. Team Member Roles & Sprint Assignments

### **Mohib Khan (Mohibkhan Pathan)**
**Role:** Backend Lead & API Architecture

**Primary Sprints:** S1, S4, S5, S10, S13

**Responsibilities:**
- Repository infrastructure and setup (S1)
- FastAPI backend development (S4, S5)
- API endpoint design and implementation
- Operations and monitoring systems (S10)
- Request timing and error logging
- Presentation slides (S13)

---

### **Monesh Pulla**
**Role:** Full-Stack Developer & Data Visualization

**Primary Sprints:** S1, S2, S3, S6, S11, S13

**Responsibilities:**
- Data fetching and ETL (S1, S2)
- Feature engineering and visualization (S3)
- Web UI development and enhancement (S6)
- User experience and mobile responsiveness
- Evaluation plots and metrics visualization (S7)
- Polish and accessibility (S11)
- Demo video recording (S13)

---

### **Dhruv Khut**
**Role:** Graph & Routing Engine Lead

**Primary Sprints:** S1, S2, S4, S8, S9, S13

**Responsibilities:**
- OSM graph building (S1, S2)
- Routing algorithms and composite cost (S4)
- Robustness and error handling (S8)
- Data refresh pipeline (S9)
- Cached fallback mechanisms
- Artifact packaging (S13)

---

### **Naga Lakshmi Gurrala**
**Role:** Risk Modeling & Evaluation Lead

**Primary Sprints:** S1, S3, S5, S7, S13

**Responsibilities:**
- Risk scoring and modeling (S1, S3)
- Temporal conditioning and recency decay
- Constraints implementation (S4)
- Explainability system (S5)
- Evaluation framework and methodology (S7)
- Limitations and bias documentation (S8)
- Final report writing (S13)

---

### **Rahul Dhingra**
**Role:** ML & Testing Lead

**Primary Sprints:** S1, S3, S4, S7, S9, S13

**Responsibilities:**
- Routing demo implementation (S1)
- Hotspot detection and ML features (S3)
- Risk classifier training (S4)
- Testing and validation (S6, S9)
- Evaluation metrics (S7)
- Regression testing (S9)
- Final code review (S13)

---

## 6. Sprint Details Summary

### Semester 1 Sprints

**S1 (Sep 2-15):** Environment Setup
- Repo, dependencies, sample data, small graph, basic routing demo
- **Deliverable:** Working Fastest vs Safest demo

**S2 (Sep 16-29):** Data & Graph Baseline
- Full SF graph, full-city SFPD data, incident attribution
- **Deliverable:** 10k node graph, 400k incident dataset

**S3 (Sep 30-Oct 13):** Risk Features v1
- Hotspot detection, temporal bins, recency decay, type weighting
- **Deliverable:** edge_features.parquet with enriched features

**S4 (Oct 14-27):** 3-Route Engine
- Train classifier, composite cost, Balanced route, constraints
- **Deliverable:** API returning Fastest/Balanced/Safest

**S5 (Oct 28-Nov 10):** Explainability & Alerts
- Plain-language explanations, high-risk alerts
- **Deliverable:** Routes with explanations and alerts

**S6 (Nov 11-24):** Web UI Enhancement
- User preferences, 3-route comparison, mobile responsive
- **Deliverable:** Enhanced interactive web app

### Semester 2 Sprints

**S7 (Feb 3-16):** Evaluation Framework
- 50 O-D pairs, metrics, latency benchmarks
- **Deliverable:** Evaluation report with plots

**S8 (Feb 17-Mar 2):** Robustness
- Error handling, fallbacks, bias documentation
- **Deliverable:** Comprehensive error handling

**S9 (Mar 3-16):** Data Refresh Pipeline
- End-to-end refresh, versioning, regression tests
- **Deliverable:** `make refresh` command

**S10 (Mar 17-30):** Operations
- Logging, metrics, runbook, reproducibility
- **Deliverable:** Complete operational runbook

**S11 (Mar 31-Apr 13):** Polish
- UX refinements, POI density (optional), performance
- **Deliverable:** Polished user experience

**S12 (Apr 14-27):** Stabilization
- Bug fixes, final metrics, demo script
- **Deliverable:** Production-ready system

**S13 (Apr 28-May 11):** Final Delivery
- Report, slides, demo video, documentation
- **Deliverable:** Complete project submission

---

## 7. Dependency Matrix

| Sprint | Depends On | Blocks | Parallel Possible? |
|--------|------------|--------|--------------------|
| S1 | None | S2 | No |
| S2 | S1 | S3 | No |
| S3 | S2 | S4 | No |
| S4 | S3 | S5 | No |
| S5 | S4 | S6, S7 | No |
| S6 | S5 | S7 | Yes (has slack) |
| S7 | S6 | S8, S9 | No |
| S8 | S7 | S9 | Yes (has slack) |
| S9 | S8 | S10, S11 | No |
| S10 | S9 | S11, S12 | Yes (has slack) |
| S11 | S10 | S12 | Yes (has slack) |
| S12 | S11 | S13 | No |
| S13 | S12 | None | No |

---

## 8. Risk Mitigation

| Risk | Impact | Mitigation | Owner |
|------|--------|------------|-------|
| SFPD data unavailable | High | Cache dated snapshots | Monesh |
| OSM download throttle | Medium | Use Geofabrik extracts | Dhruv |
| Team member unavailable | Medium | Cross-training, slack time | All |
| Performance issues | Medium | Caching, optimization | Mohib |
| Scope creep | Low | Strict sprint boundaries | All |

---

## 9. Success Criteria

- ✅ 3-route engine (Fastest/Balanced/Safest) operational
- ✅ Routing latency ≤5s P95
- ✅ Risk reduction vs fastest baseline demonstrated
- ✅ Plain-language explanations working
- ✅ Complete documentation and reproducibility
- ✅ Final demo and presentation delivered

---

**End of WB2-9 Project Schedule**
