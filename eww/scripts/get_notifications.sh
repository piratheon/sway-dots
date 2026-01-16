#!/bin/bash
dunstctl history 2>/dev/null | jq -c '[.data[0][]? | {
  appname: .appname.data,
  summary: .summary.data,
  id: .id.data,
  icon: .icon_path.data
}] // []' 2>/dev/null || echo '[]'
