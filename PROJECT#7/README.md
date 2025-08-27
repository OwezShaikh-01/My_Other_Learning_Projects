# CTA Ridership Analytics

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Tableau](https://img.shields.io/badge/Tableau-Dashboard-orange.svg)]()
[![SQL](https://img.shields.io/badge/SQL-Analysis-blue.svg)]()

## 📊 Overview

This project provides comprehensive analysis of Chicago Transit Authority (CTA) ridership data from 2001-2025 (April) to uncover patterns, trends, and anomalies in public transportation usage. Through advanced feature engineering, statistical profiling, and segmentation techniques, this study identifies key drivers of ridership, evaluates the impact of external factors (including COVID-19), and highlights critical routes and time segments for strategic planning.

## 🎯 Objectives

- Analyze temporal trends and seasonal patterns in CTA ridership
- Assess COVID-19 pandemic impact on transit usage
- Identify high-performing routes and anomalies
- Segment ridership by behavioral patterns
- Create interactive visualizations for data-driven decision making

## 📈 Data Source

**Dataset**: Chicago CTA Ridership Data  
**Source**: [Chicago CTA Ridership](https://data.cityofchicago.org/api/views/jyb9-n7fm/rows.csv?accessType=DOWNLOAD)

### Dataset Specifications
- **Total Records**: ~1,050,000 rows
- **Columns**: 4
- **Fields**: 
  - `route` (Text) - Transit route identifier
  - `date` (Timestamp) - Date of ridership record
  - `daytype` (Text) - Day classification (W/A/U)
  - `rides` (Number) - Number of rides
- **Time Period**: 2001 - 2025 (April)

## 🛠️ Technology Stack

- **SQL** - Data cleaning, transformation, and analysis
- **Tableau** - Dashboard design and interactive visualization
- **AI Web Scraping** - Additional data enrichment
- **Statistical Analysis** - Anomaly detection and pattern recognition

## 📋 Project Methodology

### Phase A & B: Data Exploration & Feature Engineering
**Research Question**: *What is the overall scope, quality, and structural integrity of our CTA ridership dataset, and does it provide comprehensive coverage across routes and time periods for reliable analysis?*

- Data validation and quality assessment
- Structural integrity verification
- Missing value treatment
- Data type standardization

### Phase C: Descriptive Statistics & Distribution Profiling
**Research Question**: *How can we enhance the CTA ridership dataset with derived attributes to enable segmented analysis and visualization of transit patterns?*

- Created ride volume buckets for segmentation
- Implemented route ranking system
- Added weekend/weekday classification flags
- Statistical distribution analysis

### Phase D: Temporal Trend Analysis
**Research Question**: *What are the long-term temporal trends and seasonal patterns in CTA ridership, including year-over-year changes and daily/weekly variations?*

- Long-term trend identification
- Seasonal pattern analysis
- Year-over-year comparison
- Daily and weekly variation assessment

### Phase E: COVID-19 Impact Assessment
**Research Question**: *How did the COVID-19 pandemic impact CTA ridership patterns across different phases, and which routes showed resilience during the crisis?*

- Pre/during/post-COVID period analysis
- Route resilience evaluation
- Recovery pattern identification
- Pandemic impact quantification

### Phase F: Magnitude, Ranking & Contribution Analysis
**Research Question**: *Which routes, days, and segments contribute most significantly to overall CTA ridership, and how concentrated is transit demand across the network?*

- Route performance ranking
- Traffic concentration analysis
- Peak segment identification
- Contribution share calculation

### Phase G: Outlier & Anomaly Detection
**Research Question**: *What are the statistical outliers and anomalies in CTA ridership data that require investigation?*

- Statistical outlier detection using Z-scores
- Anomaly pattern identification
- Data quality issue investigation
- Extreme value analysis

### Phase H: Segmentation & Behavioral Patterns
**Research Question**: *How can CTA ridership be segmented by behavioral patterns, and what distinct usage profiles emerge across different route categories?*

- Behavioral pattern segmentation
- Usage profile classification
- Route category analysis
- Temporal usage patterns


## 📊 Dashboard Features

![CTA Ridership Dashboard](dashboard/Dashboard.png)

### Key Metrics Summary
- **Total Rides**: 6.2B rides (2001-2025 April)
- **Average Daily Rides**: 704,778 rides
- **Most Busy Route**: Ashland (20,783 Avg Peak rides)
- **Peak Month**: October 2008 (3.10M rides)
- **Lowest Month**: April 2020 (58.1K rides)

### Key Visualizations
- **Ridership Trend**: Time series analysis showing overall ridership patterns from 2001-2025
- **Top 10 Routes Performance**: Horizontal bar chart ranking routes by total ridership
- **Weekday vs Weekend**: Comparative analysis showing weekday dominance over weekend usage
- **Monthly Heatmap**: Seasonal ridership patterns across years and months
- **YoY Growth Analysis**: Year-over-year percentage change tracking
- **Day-wise Distribution**: Weekly ridership patterns from Tuesday to Sunday
- **Route Performance Timeline**: Individual route trend analysis with filtering capability

### Interactive Features
- **Date Range Filter**: 2001 to April 2025 (Dynamic filtering)
- **Route-specific Analysis**: Drill-down capabilities for individual route performance
- **Multi-dimensional Filtering**: Route filter with "All" option for comprehensive view
- **Real-time Calculations**: Dynamic metric updates based on filter selections

### Key Performance Indicators
- Average daily ridership
- Route volatility metrics
- Seasonal variation coefficients
- Peak usage identification


## 📁 Project Structure
```
CTA-Ridership-Analytics/
├── Dashboard/
│   ├── Dashboard.png
│   └── PROJECT#7.twbx
├── Datasets/
│   └── Original_Dataset/
│       └── CTA_-_Ridership_-_Bus_Routes_-_Daily_Totals_by_Route.csv
│   ├── ridership_featured.csv
│   ├── ridership_raw.csv
│   └── route_lookup.csv
├── Scripts/
│   ├── PHASE_0 - Database Setup & Gold Table Creation.sql
│   ├── PHASE_A - Database Exploration.sql
│   ├── PHASE_B - Feature Engineering.sql
│   ├── PHASE_C - Statistics & Distribution Profiling.sql
│   ├── PHASE_D - Temporal Trend Analysis.sql
│   ├── PHASE_E - COVID Analysis.sql
│   ├── PHASE_F - Magnitude & Ranking Analysis.sql
│   ├── PHASE_G - Anomaly Detection.sql
│   └── PHASE_H - Segmentation.sql 
└── README.md
```

## 🔍 Key Insights

Based on the comprehensive analysis of CTA ridership data (2001-2025 April):

### Ridership Volume & Performance
- **Total System Usage**: 6.2 billion rides over the analysis period
- **Daily Average**: 704,778 rides per day
- **Top Performing Route**: Ashland line with 20,783 Peak Avg Rides
- **Route Concentration**: Top 10 routes account for majority of system ridership

### Temporal Patterns
- **Weekday Dominance**: Significantly higher ridership during weekdays compared to weekends
- **Seasonal Variations**: October historically shows peak ridership (3.10M in 2008)
- **Long-term Trends**: Observable ridership fluctuations with notable recovery patterns
- **Weekly Patterns**: Tuesday through Friday show consistently high ridership

### Behavioral Insights
- **Commuter-Focused System**: High weekday usage indicates strong commuter dependency
- **Route Specialization**: Different routes serve distinct ridership patterns and volumes
- **Seasonal Sensitivity**: Clear monthly variations suggesting weather and event impacts

## 📈 Business Impact

This analysis enables stakeholders to:
- **Optimize Resource Allocation**: Data-driven route planning and scheduling
- **Strategic Planning**: Long-term transit system improvements
- **Crisis Response**: Better preparation for future disruptions
- **Performance Monitoring**: Continuous system optimization
- **Policy Development**: Evidence-based transit policies

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

## 👤 Author

**[Your Name]**
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/yourprofile)

## 🙏 Acknowledgments

- Chicago Transit Authority for providing open ridership data
- Tableau community for visualization best practices

---

**Note**: This project is for analytical and educational purposes. All data used is publicly available and properly attributed.