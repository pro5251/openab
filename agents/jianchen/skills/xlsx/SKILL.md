---
name: xlsx
description: Backend processing of Excel files (XLSX). Use when the user wants to import/export data, generate reports, or parse spreadsheets.
---

# XLSX Data Processing

## Tools
*   `xlsx` (Node.js) or `openpyxl` / `pandas` (Python)

## Process
1.  **Parsing**: Read the file and convert rows to JSON objects.
2.  **Validation**: Ensure columns match the expected schema and data types.
3.  **Generation**: Create a new workbook, define styles, and populate data.
4.  **Output**: Provide the file as a buffer or save to disk.
