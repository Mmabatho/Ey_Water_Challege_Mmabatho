-- 1️⃣ Create External Access Integration using Snowflake’s built-in PyPI rule

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION pypi_access_integration
  ALLOWED_NETWORK_RULES = (snowflake.external_access.pypi_rule)
  ENABLED = TRUE;

-- 2️⃣ Verify it was created

SHOW EXTERNAL ACCESS INTEGRATIONS;

DESC EXTERNAL ACCESS INTEGRATION EY_EXTERNAL_ACCESS;

DESC NETWORK RULE EY_WATER_QUALITY.CHALLENGE.EY_PYPI_RULE;