-- EY 2026 AI & Data Challenge
-- Snowflake Mandatory Setup Script

-- ------------------------------------------------------------
-- 1. Create Challenge Database
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS EY_WATER_QUALITY;
USE DATABASE EY_WATER_QUALITY;

-- ------------------------------------------------------------
-- 2. Create Schema
-- ------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS CHALLENGE;
USE SCHEMA CHALLENGE;

-- ------------------------------------------------------------
-- 3. Create Warehouse (sufficient for notebooks & ML)
-- ------------------------------------------------------------
CREATE WAREHOUSE IF NOT EXISTS EY_WH
  WITH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 120
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

USE WAREHOUSE EY_WH;

-- ------------------------------------------------------------
-- 4. Network Rules (External API Access)
--    Required for Landsat + TerraClimate
-- ------------------------------------------------------------

-- Google Earth Engine / Landsat
CREATE OR REPLACE NETWORK RULE EY_GOOGLE_APIS_RULE
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = (
    'earthengine.googleapis.com',
    'storage.googleapis.com',
    'oauth2.googleapis.com',
    'landsatlook.usgs.gov'
  );

-- Planetary Computer / TerraClimate
CREATE OR REPLACE NETWORK RULE EY_PLANETARY_COMPUTER_RULE
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = (
    'planetarycomputer.microsoft.com',
    'api.planetarycomputer.microsoft.com',
    'planetarycomputer.blob.core.windows.net',
    '*.blob.core.windows.net',
    '*.dfs.core.windows.net',
    'login.microsoftonline.com'
  );

-- Python package repositories (needed in notebooks)
CREATE OR REPLACE NETWORK RULE EY_PYPI_RULE
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = (
    'pypi.org',
    'pypi.python.org',
    'pythonhosted.org',
    'files.pythonhosted.org'
  );

-- ------------------------------------------------------------
-- 5. External Access Integration
-- ------------------------------------------------------------
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION EY_EXTERNAL_ACCESS
  ALLOWED_NETWORK_RULES = (
    EY_GOOGLE_APIS_RULE,
    EY_PLANETARY_COMPUTER_RULE,
    EY_PYPI_RULE
  )
  ENABLED = TRUE;

-- ------------------------------------------------------------
-- 6. Grant Access to Integration
-- ------------------------------------------------------------
GRANT USAGE ON INTEGRATION EY_EXTERNAL_ACCESS TO ROLE PUBLIC;

-- ------------------------------------------------------------
-- 7. Grant Database & Warehouse Usage
-- ------------------------------------------------------------
GRANT USAGE ON DATABASE EY_WATER_QUALITY TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA EY_WATER_QUALITY.CHALLENGE TO ROLE PUBLIC;
GRANT USAGE ON WAREHOUSE EY_WH TO ROLE PUBLIC;

-- ------------------------------------------------------------
-- 8. Verification (DO NOT SKIP)
-- ------------------------------------------------------------

-- Verify External Access Integration
SHOW INTEGRATIONS LIKE 'EY_EXTERNAL_ACCESS';

-- Verify Network Rules
SHOW NETWORK RULES;

-- Verify Database & Schema
SHOW DATABASES LIKE 'EY_WATER_QUALITY';
SHOW SCHEMAS IN DATABASE EY_WATER_QUALITY;

-- Verify Warehouse
SHOW WAREHOUSES LIKE 'EY_WH';

SHOW INTEGRATIONS;


CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION ey_apis_integration
  ALLOWED_NETWORK_RULES = (planetary_computer_rule)
  ENABLED = TRUE;

  DESCRIBE GIT REPOSITORY EY_WATER_QUALITY.PUBLIC.EY_WATER_CHALLEGE_MMABATHO;

 -- 1. Use the correct database and schema
USE DATABASE EY_WATER_QUALITY;
USE SCHEMA CHALLENGE;

-- 2. Create the Secret (Replace 'ghp_xxx' with your actual GitHub Token)
CREATE OR REPLACE SECRET GITHUB_TOKEN
  TYPE = PASSWORD
  USERNAME = 'YourGitHubUsername'
  PASSWORD = 'ghp_YourActualGitHubTokenHere';

-- 3. Grant permissions to yourself (Standard role is usually ACCOUNTADMIN or SYSADMIN for the challenge)
GRANT USAGE ON DATABASE EY_WATER_QUALITY TO ROLE ACCOUNTADMIN;
GRANT USAGE ON SCHEMA EY_WATER_QUALITY.CHALLENGE TO ROLE ACCOUNTADMIN;
GRANT READ ON SECRET EY_WATER_QUALITY.CHALLENGE.GITHUB_TOKEN TO ROLE ACCOUNTADMIN;