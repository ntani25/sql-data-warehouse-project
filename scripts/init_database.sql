/*
=========================================================================================
Create Schemas
=========================================================================================
Script Purpose:
  This script creates three new databases named 'dw_bronze', 'dw_silver', and 'dw_gold'.

NOTE:
  Since MySQL lacks a three-layer hierarchy (Instance → Database → Schema), you cannot create a single database called "DataWarehouse" and nest Bronze, Silver, and Gold schemas inside it. 
  Instead, you should create three separate MySQL databases on your server.
*/

-- Create Schemas

CREATE DATABASE dw_bronze;

CREATE DATABASE dw_silver;

CREATE DATABASE dw_gold;
