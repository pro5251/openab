---
name: skill-search
description: 技能搜尋與安裝 Skill — 搜尋專案技能庫並安裝至 Gemini CLI 技能目錄
---

# 技能搜尋與安裝 Skill — Gemini Agent

> **觸發條件**：當使用者詢問、或發現任務缺少技能輔佐時，詢問是否啟動此技能。

## 執行流程

### Step 1：搜尋
搜尋專案技能庫：
- `awesome-claude-skills\awesome-claude-skills`
- `anthropics\skills`
- `mattpocock\skills`

### Step 2：安裝
1. 將搜尋到的技能檔案複製或轉換為符合 Gemini CLI 格式的 `SKILL.md`。
2. 安裝位置：`./agents/{your_name}/skills/{skill-name}/SKILL.md`。

## 注意事項
- 安裝前必須詢問使用者。
- 確保技能描述符合實務需求。
