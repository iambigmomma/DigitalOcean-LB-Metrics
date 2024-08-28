#!/bin/bash

# Base URL for your API
base_url="https://api.digitalocean.com/v2"

# Ensure the API token is available
if [ -z "$DO_API_TOKEN" ]; then
  echo "DO_API_TOKEN is not set. Please export it as an environment variable."
  exit 1
fi

# Fetch Load Balancer IDs
lb_endpoint="$base_url/load_balancers"
echo "Fetching list of Load Balancers..."
lb_ids=$(curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $DO_API_TOKEN" "$lb_endpoint" | jq -r '.load_balancers[] | .id + " (" + .name + ")"')

# Check if Load Balancer IDs were fetched
if [ -z "$lb_ids" ]; then
  echo "Failed to fetch Load Balancers or no Load Balancers found."
  exit 1
fi

# Display Load Balancer IDs
echo "Available Load Balancers:"
echo "$lb_ids"
echo

# User selects a Load Balancer
read -p "Enter Load Balancer ID from the list above: " lb_id

# Display metric category choices
echo "Select a category to fetch metrics:"
echo "1) Frontend Metrics"
echo "2) Droplet-Level Metrics"
echo "3) Network-Level Metrics"
read -p "Enter your choice (1-3): " category_choice

# Assign endpoints based on user choice
case $category_choice in
    1)
        endpoints="/load_balancer/frontend_http_requests_per_second /load_balancer/frontend_connections_current /load_balancer/frontend_connections_limit /load_balancer/frontend_cpu_utilization /load_balancer/frontend_network_throughput_http /load_balancer/frontend_network_throughput_udp /load_balancer/frontend_network_throughput_tcp /load_balancer/frontend_http_responses /load_balancer/frontend_tls_connections_current /load_balancer/frontend_tls_connections_limit /load_balancer/frontend_tls_connections_exceeding_rate_limit"
        ;;
    2)
        endpoints="/load_balancer/droplets_http_session_duration_avg /load_balancer/droplets_http_session_duration_50p /load_balancer/droplets_http_session_duration_95p /load_balancer/droplets_http_response_time_avg /load_balancer/droplets_http_response_time_50p /load_balancer/droplets_http_response_time_95p /load_balancer/droplets_http_response_time_99p /load_balancer/droplets_queue_size /load_balancer/droplets_http_responses /load_balancer/droplets_connections /load_balancer/droplets_health_checks /load_balancer/droplets_downtime"
        ;;
    3)
        endpoints="/load_balancer/frontend_nlb_tcp_network_throughput /load_balancer/frontend_nlb_udp_network_throughput /load_balancer/load_balancer_firewall_dropped_bytes /load_balancer/load_balancer_firewall_dropped_packets"
        ;;
    *)
        echo "Invalid selection."
        exit 1
        ;;
esac

# Predefined time periods (past 1 hour, 24 hours, 3 days, 7 days)
current_time=$(date +%s)
one_hour_ago=$(($current_time - 3600))
one_day_ago=$(($current_time - 86400))
three_days_ago=$(($current_time - 259200))
seven_days_ago=$(($current_time - 604800))

# Time periods array
declare -a periods=(
  "$one_hour_ago $current_time"
  "$one_day_ago $current_time"
  "$three_days_ago $current_time"
  "$seven_days_ago $current_time"
)

# Loop through predefined time periods and fetch metrics
for period in "${periods[@]}"; do
  read start end <<< "$period"
  echo "Fetching metrics from $start to $end..."
  for endpoint in $endpoints; do
    url="${base_url}/monitoring/metrics${endpoint}?lb_id=${lb_id}&start=${start}&end=${end}"
    echo "URL: $url"
    response=$(curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $DO_API_TOKEN" "$url")
    echo "Metrics for $endpoint from $start to $end:"
    echo "$response"
    echo "-------------------------------------------------------"
  done
done
