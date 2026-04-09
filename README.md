# 🛒 E-Commerce Dashboard 2.0 (Power BI & SQL)

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Data Analytics](https://img.shields.io/badge/Data_Analytics-005571?style=for-the-badge)

Welcome to the **E-Commerce 2.0** data project! This repository contains a complete end-to-end data analytics solution. It includes a custom T-SQL script to build and populate an e-commerce database from scratch, paired with a fully interactive Power BI dashboard designed to track, analyze, and optimize business performance. 

## 📑 Table of Contents
- [About the Project](#about-the-project)
- [Database Schema](#database-schema)
- [Dashboard Features](#dashboard-features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [License](#license)

## 📊 About the Project
**E-Commerce 2.0** is an advanced analytics solution designed for e-commerce store owners, data analysts, and marketing teams. The project bridges the gap between backend data architecture and frontend visualization, transforming raw relational data into actionable insights for monitoring KPIs, customer journey flows, and marketing campaign success.

<img width="1266" height="641" alt="image" src="https://github.com/user-attachments/assets/13358946-8160-4891-bc83-d1b807e1491d" />
<img width="1314" height="748" alt="image" src="https://github.com/user-attachments/assets/a67b2f24-5b3a-41a7-850b-676009891d8a" />
<img width="1302" height="725" alt="image" src="https://github.com/user-attachments/assets/e5f5c760-d229-4f8e-b66c-caba33c6c1d1" />
<img width="1275" height="720" alt="image" src="https://github.com/user-attachments/assets/12316a56-afac-49e6-9366-2a0c2c1485b8" />
<img width="1281" height="729" alt="image" src="https://github.com/user-attachments/assets/f4f4fbfe-177d-40cf-89ca-9df25917a088" />
<img width="1302" height="726" alt="image" src="https://github.com/user-attachments/assets/87365672-ef64-402b-9056-69acea0747dd" />
<img width="1251" height="728" alt="image" src="https://github.com/user-attachments/assets/6d389b9c-1ee7-4011-92db-890517430e3e" />



## 🗄️ Database Schema
The included `e-comlast code.sql` script sets up a relational database (`EcommerceDB`) containing the following core tables:
* **CustomerInformation**: Demographics, location, and customer types.
* **ProductDetails**: Product names, categories, and pricing.
* **OrderDetails**: Order tracking, delivery dates, and status.
* **TransactionDetails**: Payment methods, transaction status, and payment platforms.
* **WebsiteInteractionMetrics**: Device types, session durations, page views, and bounce rates.
* **MarketingCampaigns**: Campaign mediums, engagement levels, and conversion tracking.

## ✨ Dashboard Features
- **Sales & Revenue Tracking**: High-level KPI cards displaying total revenue, orders, and profit margins.
- **Customer Journey Flow**: Utilizes custom Sankey diagrams to map out the user journey and drop-off points.
- **Platform Analytics**: Compares mobile shopping vs. desktop shopping metrics.
- **Custom Theming**: Features a cohesive, custom-built Power BI theme (JSON) and embedded dynamic assets (GIFs/MP4s) for an enhanced UI/UX.

## 💻 Prerequisites
To set up and interact with this project, you will need:
- **[Power BI Desktop](https://powerbi.microsoft.com/desktop/)** (Free to download, Windows OS required)
- **SQL Server / T-SQL Client** (e.g., SQL Server Management Studio, Azure Data Studio, or DBeaver) to run the provided `.sql` database script.

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/your-username/ecommerce-powerbi-2.0.git](https://github.com/your-username/ecommerce-powerbi-2.0.git)ername/ecommerce-powerbi-2.0.git](https://github.com/your-username/ecommerce-powerbi-2.0.git)

2. **Set up the Database:**
Open your SQL Server client and execute the e-comlast code.sql file. This script will automatically create the EcommerceDB database, build the tables, and populate them with sample data for the dashboard.**

3. **Open the Dashboard:**
Navigate to the repository folder and double-click the E-commerce 2.0.pbix file to open it in Power BI Desktop.

4. **Connect to your Local Server:**
In Power BI, click on Transform Data -> Data Source Settings. Update the SQL Server credentials to point to your local server instance, then click Close & Apply to refresh the data.

This project is licensed under the MIT License - see the LICENSE file for details.
